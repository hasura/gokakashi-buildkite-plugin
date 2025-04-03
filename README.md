# GoKakashi Scan Buildkite Plugin

A Buildkite plugin that integrates container image vulnerability scans directly into your CI/CD pipelines using the GoKakashi API.

## Features

- Trigger scans for container images based on policies defined in your GoKakashi configuration
- Monitor scan progress with customizable retry and interval settings
- Fetch and output scan reports as part of your CI/CD pipeline
- Supports integration with Cloudflare Access headers for secured API access

## Requirements

- [Buildkite Agent](https://buildkite.com/docs/agent)
- Docker (The plugin runs in a container environment)

## Configuration

### Required

- `server` (string): The URL of the GoKakashi API server
- `token` (string): Authentication token for the GoKakashi server
- Either `image` or `scan_id` must be provided:
  - `image` (string): The container image to scan
  - `scan_id` (string): The ID of a previously triggered scan

### Optional

- `policy` (string): The policy to use for scanning (required when `image` is provided)
- `labels` (string): Labels to add to the scan (required when `image` is provided)
- `cf_client_id` (string): Cloudflare Access Client ID
- `cf_client_secret` (string): Cloudflare Access Client Secret
- `interval` (integer): Interval in seconds to check the scan status (default: 10)
- `retries` (integer): Number of retries before marking the scan as failed (default: 10)
- `gokakashi_version` (string): The version of GoKakashi to use (e.g., `v0.1.0`, `latest`) (default: `latest`)
- `debug` (boolean): Enable `-x` flag to print verbose logs (default: `false`)

## Example Usage

Add the following to your `pipeline.yml`:

```yaml
steps:
  - label: ":shield: Scan Container Image"
    plugins:
      - hasura/gokakashi#v0.1.0:
          server: "https://your-gokakashi-server.com"
          token: "${GOKAKASHI_TOKEN}"
          image: "your-registry/your-image:latest"
          policy: "default"
          labels: "buildkite,ci"
```

### Using with Cloudflare Access

```yaml
steps:
  - label: ":shield: Scan Container Image"
    plugins:
      - hasura/gokakashi#v0.1.0:
          server: "https://your-gokakashi-server.com"
          token: "${GOKAKASHI_TOKEN}"
          image: "your-registry/your-image:latest"
          policy: "default"
          labels: "buildkite,ci"
          cf_client_id: "${CF_CLIENT_ID}"
          cf_client_secret: "${CF_CLIENT_SECRET}"
```

### Checking an Existing Scan

```yaml
steps:
  - label: ":shield: Check Existing Scan"
    plugins:
      - hasura/gokakashi#v0.1.0:
          server: "https://your-gokakashi-server.com"
          token: "${GOKAKASHI_TOKEN}"
          scan_id: "your-existing-scan-id"
```

## Output

- The plugin stores the report URL in Buildkite metadata as `gokakashi-report-url`
- You can access this in downstream steps using: `$(buildkite-agent meta-data get gokakashi-report-url)`

## Security

Ensure that you store sensitive information like API tokens and Cloudflare Access credentials as [Buildkite Pipeline Secrets](https://buildkite.com/docs/pipelines/secrets).

## License

This project is licensed under the Apache 2.0 License.

## Support

For questions or support, please open an issue in the GitHub repository.
