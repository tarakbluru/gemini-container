# Gemini Container Tool 🤖

A containerized development environment for [Google Gemini CLI](https://github.com/google/generative-ai-python) using Podman/Docker. This tool provides an isolated, portable workspace for AI-assisted development with Google's Gemini AI across multiple projects.

## 🚀 Features

- **Project-based isolation**: Each project gets its own Gemini container instance
- **Persistent workspace**: Your project files are mounted into the container
- **Easy management**: Simple PowerShell scripts for starting and stopping containers
- **Podman support**: Built for Podman but compatible with Docker
- **Cross-platform**: Works on Windows, Linux, and macOS
- **Multiple AI models**: Access to Gemini Pro, Gemini Pro Vision, and other Google AI models

## 📋 Prerequisites

- [Podman](https://podman.io/getting-started/installation) or [Docker](https://docs.docker.com/get-docker/)
- PowerShell (for Windows users)
- Valid Google AI Studio API key

## 🛠️ Installation

1. **Clone this repository:**
   ```bash
   git clone <repository-url>
   cd gemini-container-tool
   ```

2. **Build the Gemini container image:**
   ```bash
   podman build -t gemini-dev .
   ```
   
   Or with Docker:
   ```bash
   docker build -t gemini-dev .
   ```

3. **Set up your API key:**
   - Get your API key from [Google AI Studio](https://aistudio.google.com/app/apikey)
   - Copy `.env.example` to `.env` and add your API key:
     ```bash
     GEMINI_API_KEY=your_api_key_here
     ```

## 🖥️ Usage

### Starting Gemini for a Project

Navigate to your project directory and run the start script:

```powershell
# Windows PowerShell
F:\path\to\gemini-container\start-gemini.ps1
```

```bash
# Linux/macOS (adapt the PowerShell logic to bash if needed)
# You can run the equivalent commands manually or create a bash version
```

The script will:
- Use your current directory as the project workspace
- Create a container named after your project folder
- Mount your project files into `/workspace` in the container
- Start an interactive bash session with Gemini CLI available

### Stopping Gemini for a Project

From the same project directory:

```powershell
# Windows PowerShell
F:\path\to\gemini-container\stop-gemini.ps1
```

This will:
- Stop the container for the current project
- Remove the container and associated volumes
- Show any remaining Gemini containers

### PowerShell Profile Setup (Recommended)

For easier access, add these functions to your PowerShell profile:

```powershell
# Add to your PowerShell profile ($PROFILE)
function Start-Gemini { 
    F:\path\to\your\gemini_container\start-gemini.ps1 
}

function Stop-Gemini { 
    F:\path\to\your\gemini_container\stop-gemini.ps1 
}
```

**To set up:**
1. Open PowerShell and run: `notepad $PROFILE`
2. Add the functions above (adjust paths to match your installation)
3. Save and restart PowerShell
4. Now you can simply run `Start-Gemini` or `Stop-Gemini` from any project directory

### Using Gemini CLI Commands

Once inside the container, you can use various Gemini CLI commands:

```bash
# Interactive chat with Gemini
python -m google.generativeai.cli chat

# Generate content from a prompt
python -m google.generativeai.cli generate "Explain quantum computing in simple terms"

# Generate content from a file
python -m google.generativeai.cli generate --file input.txt

# Generate code
python -m google.generativeai.cli generate "Write a Python function to sort a list"

# Use with different models
python -m google.generativeai.cli generate --model gemini-pro "Your prompt here"
```

### Manual Container Management

You can also manage containers manually:

```bash
# Start container for current directory
export WORKSPACE_DIR=$(pwd)
export GEMINI_API_KEY="your_api_key"
podman compose -p $(basename $(pwd)) up -d

# Connect to running container
podman compose -p $(basename $(pwd)) exec gemini-dev bash

# Stop container
podman compose -p $(basename $(pwd)) down
```

## 📁 Project Structure

```
gemini-container-tool/
├── Dockerfile              # Container definition with Gemini CLI
├── docker-compose.yml      # Service configuration
├── start-gemini.ps1        # PowerShell script to start Gemini
├── stop-gemini.ps1         # PowerShell script to stop Gemini
├── .env                    # Environment variables (API keys)
└── README.md               # This file
```

## 🔧 Configuration

### Environment Variables

- `WORKSPACE_DIR`: Directory to mount as workspace (automatically set by scripts)
- `GEMINI_API_KEY`: Your Google AI Studio API key (required)
- `GOOGLE_APPLICATION_CREDENTIALS`: Path to service account JSON (optional, for advanced usage)

### Customizing the Container

Modify the `Dockerfile` to:
- Add additional development tools
- Install project-specific dependencies
- Configure shell preferences

Example additions:
```dockerfile
FROM python:3.11-slim

# Install system dependencies
RUN apt-get update && apt-get install -y \
    git vim curl jq \
    && rm -rf /var/lib/apt/lists/*

# Install Gemini CLI and other Python packages
RUN pip install google-generativeai requests beautifulsoup4

# Install Node.js for additional tools
RUN curl -fsSL https://deb.nodesource.com/setup_lts.x | bash - && \
    apt-get install -y nodejs

WORKDIR /workspace
CMD ["bash"]
```

## 💡 Available Gemini Models

The CLI supports various Google AI models:

- `gemini-pro`: Most capable model for text generation
- `gemini-pro-vision`: Supports both text and image inputs
- `gemini-1.5-pro`: Latest and most advanced model
- `text-bison`: PaLM 2 text model
- `chat-bison`: PaLM 2 chat model

## 🔍 Example Use Cases

### Code Generation
```bash
python -m google.generativeai.cli generate "Create a REST API in Python using FastAPI for a todo list application"
```

### Code Review
```bash
python -m google.generativeai.cli generate --file my_code.py "Review this code and suggest improvements"
```

### Documentation
```bash
python -m google.generativeai.cli generate "Write comprehensive documentation for this Python class" --file my_class.py
```

### Data Analysis
```bash
python -m google.generativeai.cli generate "Analyze this CSV data and provide insights" --file data.csv
```

## 🐛 Troubleshooting

### Container Won't Start
- Ensure Podman/Docker is running
- Check if the `gemini-dev` image exists: `podman images`
- Verify the docker-compose.yml path is correct

### API Key Issues
- Verify your Google AI Studio API key is correct
- Ensure the key has the necessary permissions
- Check the .env file is properly formatted

### Permission Issues
- On Linux/macOS, ensure proper file permissions
- Check SELinux settings if applicable

### PowerShell Execution Policy
```powershell
# If scripts won't run, update execution policy
Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser
```

### Rate Limiting
- Google AI Studio has rate limits
- Consider implementing delays between requests for batch operations
- Monitor your usage in the Google AI Studio console

## 🔄 Updating

To update Gemini CLI to the latest version:

```bash
# Rebuild the container
podman build -t gemini-dev . --no-cache
```

## 💰 Cost Management

- Monitor your API usage in [Google AI Studio](https://aistudio.google.com/)
- Gemini has generous free tier limits
- Consider implementing usage tracking for production use

## 🤝 Contributing

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Test with your projects
5. Submit a pull request

## 📄 License

MIT License

Copyright (c) 2024

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.

## 🆘 Support

- [Google Generative AI Python Documentation](https://github.com/google/generative-ai-python)
- [Google AI Studio](https://aistudio.google.com/)
- [Podman Documentation](https://docs.podman.io/)
- [Issues](../../issues) - Report bugs or request features

## 🙏 Acknowledgments

- [Google](https://google.com/) for Gemini AI
- [Podman](https://podman.io/) for containerization
- The open-source community

---

**Happy coding with Gemini!** 🎉