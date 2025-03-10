FROM buildkite/agent:ubuntu

# Install dependencies
RUN apt-get update && apt-get install -y \
    wget \
    curl \
    jq \
    && rm -rf /var/lib/apt/lists/*

# Set up working directory
WORKDIR /buildkite-plugin

# Copy hooks
COPY hooks /buildkite-plugin/hooks

# Make hooks executable
RUN chmod +x /buildkite-plugin/hooks/command

# Default command
CMD ["/buildkite-plugin/hooks/command"]