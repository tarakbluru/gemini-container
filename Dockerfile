FROM python:3.11-slim

# Install system dependencies
RUN apt-get update && apt-get install -y \
    git \
    curl \
    vim \
    && rm -rf /var/lib/apt/lists/*

# Install Gemini CLI
RUN pip install google-generativeai

# Create workspace directory
WORKDIR /workspace

# Default command
CMD ["bash"]