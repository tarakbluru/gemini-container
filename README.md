# Gemini CLI Container Tool 🤖

A containerized development environment for [Google Gemini CLI](https://github.com/google-gemini/gemini-cli) using Podman/Docker. This tool provides an isolated, portable workspace for AI-assisted development with Google's official Gemini CLI agent across multiple projects.

## 🚀 Features

- **Project-based isolation**: Each project gets its own Gemini CLI container instance
- **Persistent workspace**: Your project files are mounted into the container
- **Easy management**: Simple PowerShell scripts for starting and stopping containers
- **Configuration persistence**: Gemini CLI settings persist across container restarts
- **Podman support**: Built for Podman but compatible with Docker
- **Cross-platform**: Works on Windows, Linux, and macOS
- **Official Google tool**: Uses the real Gemini CLI from Google, not a wrapper

## 🎯 What is Google Gemini CLI?

Google Gemini CLI is an open-source AI agent that brings the power of Gemini directly into your terminal. It's a command-line AI workflow tool that connects to your tools, understands your code and accelerates your workflows. Key capabilities include:

- **Large codebase support**: Query and edit large codebases in and beyond Gemini's 1M token context window
- **Multimodal capabilities**: Generate new apps from PDFs or sketches, using Gemini's multimodal capabilities
- **Operational automation**: Automate operational tasks, like querying pull requests or handling complex rebases
- **Tool integration**: Use tools and MCP servers to connect new capabilities, including media generation with Imagen, Veo or Lyria
- **Web search**: Ground your queries with the Google Search tool, built in to Gemini

## 📋 Prerequisites

- [Podman](https://podman.io/getting-started/installation) or [Docker](https://docs.docker.com/get-docker/)
- PowerShell (for Windows users)
- Google account (for free authentication) OR Gemini API key

## 🛠️ Installation

1. **Clone this repository:**
   ```bash
   git clone <repository-url>
   cd gemini-container-tool
   ```

2. **Build the Gemini CLI container image:**
   ```bash
   podman build -t gemini-dev .
   ```
   
   Or with Docker:
   ```bash
   docker build -t gemini-dev .
   ```

3. **Authentication options:**
   - **Recommended**: Use Google login (free tier with 60 model requests per minute and 1,000 requests per day)
   - **Optional**: Set API key in `.env` file for higher limits or enterprise usage

## 🖥️ Usage

### Starting Gemini CLI for a Project

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

### Stopping Gemini CLI for a Project

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

### Using Gemini CLI

Once inside the container, simply run:

```bash
gemini
```

This starts the interactive Gemini CLI agent. You can:

- **Chat naturally**: Ask questions about your code or project
- **Code assistance**: Generate, review, or modify code
- **Project analysis**: Understand large codebases
- **Task automation**: Handle Git operations, deployments, etc.
- **Creative generation**: Create apps from sketches or PDFs

### Example Gemini CLI Usage

```bash
# Start Gemini CLI
gemini

# Example prompts (inside Gemini CLI):
> Analyze this codebase and explain the architecture
> Write unit tests for the main.js file
> Help me debug this React component
> Create a Dockerfile for this Node.js project
> Refactor this code to use TypeScript
> Generate a README for this project
```

### Manual Container Management

You can also manage containers manually:

```bash
# Start container for current directory
export WORKSPACE_DIR=$(pwd)
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
├── docker-compose.yml      # Service configuration with volume persistence
├── start-gemini.ps1        # PowerShell script to start Gemini
├── stop-gemini.ps1         # PowerShell script to stop Gemini
├── .env                    # Environment variables (optional API keys)
└── README.md               # This file
```

## 🔧 Configuration

### Environment Variables

- `WORKSPACE_DIR`: Directory to mount as workspace (automatically set by scripts)
- `GEMINI_API_KEY`: Optional API key for higher rate limits (free tier available via Google login)
- `GOOGLE_APPLICATION_CREDENTIALS`: Path to service account JSON (for enterprise usage)

### Authentication Methods

1. **Google Login (Recommended)**:
   - Run `gemini` and choose "Login with Google"
   - Free tier provides 60 model requests per minute and 1,000 requests per day
   - No API key required

2. **API Key**:
   - Get key from [Google AI Studio](https://aistudio.google.com/app/apikey)
   - Set in `.env` file or as environment variable
   - For higher rate limits or enterprise usage

3. **Vertex AI**:
   - For enterprise Google Cloud integration
   - Set `GOOGLE_APPLICATION_CREDENTIALS`

### Customizing the Container

Modify the `Dockerfile` to add additional tools:

```dockerfile
FROM node:20-slim

# Install system dependencies
RUN apt-get update && apt-get install -y \
    git vim curl jq \
    python3 python3-pip \
    && rm -rf /var/lib/apt/lists/*

# Install Gemini CLI globally
RUN npm install -g @google/gemini-cli

# Install additional development tools
RUN npm install -g typescript eslint prettier

# Install Python tools if needed
RUN pip3 install --break-system-packages requests beautifulsoup4

WORKDIR /workspace
CMD ["bash"]
```

## 🔒 Security Features

Gemini CLI operates as a local agent with built-in security measures that address common concerns about AI command execution. The system requires explicit user confirmation for each command, with options to "allow once," "always allow" or deny specific operations.

Security layers include:
- **User confirmation required** for all command executions
- **Sandboxing support** (native macOS Seatbelt, Docker/Podman containers)
- **Network traffic inspection** via proxy support
- **Open source transparency** - full code auditing possible
- **Limited context** - only accesses explicitly provided information

## 🎯 Use Cases

### Development Tasks
- Code generation and review
- Architecture analysis
- Bug fixing and debugging
- Test creation
- Documentation generation

### DevOps Automation
- Git operations and complex rebases
- CI/CD pipeline creation
- Infrastructure as Code generation
- Deployment automation

### Creative Projects
- App generation from PDFs or sketches
- Multi-modal content creation
- Media generation integration
- Prototype development

## 💡 Tips and Best Practices

1. **Project Context**: Place relevant documentation in `GEMINI.md` files for project-specific context
2. **Free Tier**: For the vast majority of developers, Gemini CLI will be completely free of charge
3. **Resource Management**: Stop containers when not in use to free system resources
4. **Multiple Projects**: Run multiple Gemini containers simultaneously for different projects
5. **Extensibility**: Leverage MCP servers for custom tool integration

## 🐛 Troubleshooting

### Container Won't Start
- Ensure Podman/Docker is running
- Check if the `gemini-dev` image exists: `podman images`
- Verify the docker-compose.yml path is correct

### Authentication Issues
- Try Google login first (recommended)
- If using API key, verify it's correctly set in environment
- Check [Google AI Studio](https://aistudio.google.com/) for key status

### Permission Issues
- On Linux/macOS, ensure proper file permissions
- Check SELinux settings if applicable

### PowerShell Execution Policy
```powershell
# If scripts won't run, update execution policy
Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser
```

### Gemini CLI Issues
- Check the [official troubleshooting guide](https://github.com/google-gemini/gemini-cli/blob/main/docs/troubleshooting.md)
- Review [GitHub issues](https://github.com/google-gemini/gemini-cli/issues)

## 🔄 Updating

To update Gemini CLI to the latest version:

```bash
# Rebuild the container
podman build -t gemini-dev . --no-cache
```

## 💰 Cost Management

- **Free Tier**: 60 model requests per minute and 1,000 requests per day at no charge
- **Enterprise**: Paid tiers available for higher usage or enterprise features
- Monitor usage in your Google account dashboard

## 🆚 Comparison with Alternatives

Gemini CLI is far from being the first or only AI tool for the command line. OpenAI Codex has a CLI version, as does Anthropic with Claude Code. Google Gemini CLI, however, is quite different from its two primary commercial rivals in that the tool is open source under the Apache 2.0 license.

Key advantages:
- **Open source** (Apache 2.0 license)
- **Free tier** with generous limits
- **Official Google support**
- **Extensible architecture** with MCP support

## 🤝 Contributing

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Test with your projects
5. Submit a pull request

For the official Gemini CLI:
- Visit [google-gemini/gemini-cli](https://github.com/google-gemini/gemini-cli)
- Follow their [contribution guidelines](https://github.com/google-gemini/gemini-cli/blob/main/CONTRIBUTING.md)

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

- [Official Gemini CLI Documentation](https://github.com/google-gemini/gemini-cli/blob/main/docs/index.md)
- [Google AI Studio](https://aistudio.google.com/)
- [Podman Documentation](https://docs.podman.io/)
- [Issues](../../issues) - Report bugs or request features

## 🙏 Acknowledgments

- [Google](https://google.com/) for the official Gemini CLI
- [Podman](https://podman.io/) for containerization
- The open-source community

---

**Happy coding with the official Google Gemini CLI!** 🎉