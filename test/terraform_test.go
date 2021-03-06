package test

import (
	"fmt"
	"strings"
	"testing"
	"time"

	http_helper "github.com/gruntwork-io/terratest/modules/http-helper"
	"github.com/gruntwork-io/terratest/modules/k8s"
	"github.com/gruntwork-io/terratest/modules/random"
	"github.com/gruntwork-io/terratest/modules/terraform"
	test_structure "github.com/gruntwork-io/terratest/modules/test-structure"
	"github.com/stretchr/testify/assert"
)

func TestTerraformGcpHelloWorldExample(t *testing.T) {
	t.Parallel()

	workingDir := test_structure.CopyTerraformFolderToTemp(t, "../", "terraform")

	// website::tag::1:: Get the Project Id to use
	gcpProjectId := "test-devops-assignment"

	// website::tag::2:: Give the example instance a unique name
	inputClusterName := fmt.Sprintf("test-%s", strings.ToLower(random.UniqueId()))

	// website::tag::6:: Construct the terraform options with default retryable errors to handle the most common
	// retryable errors in terraform testing.
	terraformOptions := terraform.WithDefaultRetryableErrors(t, &terraform.Options{
		// website::tag::3:: The path to where our Terraform code is located
		TerraformDir: workingDir,

		// website::tag::4:: Variables to pass to our Terraform code using -var options
		Vars: map[string]interface{}{
			"cluster_name": inputClusterName,
			"google_project": gcpProjectId,
		},
	})

	// website::tag::8:: At the end of the test, run `terraform destroy` to clean up any resources that were created
	defer terraform.Destroy(t, terraformOptions)

	// website::tag::7:: Run `terraform init` and `terraform apply`. Fail the test if there are any errors.
	terraform.InitAndApply(t, terraformOptions)

	// Get the created cluster's name and set up the access config
	outputClusterName := terraform.Output(t, terraformOptions, "cluster_name")
	kubectlOptions := k8s.NewKubectlOptions(outputClusterName, workingDir + "/kubeconfig", "default")

	// Make sure the nodes are ready and the cluster is in an operational state
	verifyGkeNodesAreReady(t, kubectlOptions)

	// website::tag::4:: Verify the service is available and get the URL for it.
	k8s.WaitUntilServiceAvailable(t, kubectlOptions, "hello-world-service", 10, 1*time.Second)
	service := k8s.GetService(t, kubectlOptions, "hello-world-service")
	url := fmt.Sprintf("http://%s", k8s.GetServiceEndpoint(t, kubectlOptions, service, 5000))

	// Verify the service type
	assert.Equal(t, "LoadBalancer", service.Spec.Type)

	// website::tag::5:: Make an HTTP request to the URL and make sure it returns a 200 OK with the body "Hello, World".
	http_helper.HttpGetWithRetry(t, url, nil, 200, "Hello world!", 30, 3*time.Second)
}
