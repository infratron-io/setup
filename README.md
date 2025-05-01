# Dotfiles Setup via 1Password and GitHub

This project helps you securely bootstrap a development environment using your private dotfiles repository, secrets from 1Password, and a simple one-liner setup.

---

## ✅ Prerequisites

- An active [1Password](https://1password.com) account.
- A GitHub personal access token or SSH key stored in your 1Password vault.
- macOS or Linux machine with `curl` and `bash` installed.

---

## 📦 One-Line Installation

Run this from your terminal:

```bash
bash <(curl -sSL https://raw.githubusercontent.com/infratron-io/setup/refs/heads/main/setup.sh)
```

This script will:

- Prompt you for your 1Password email.
- Log into your 1Password account.
- Retrieve your SSH key or GitHub token from 1Password.
- Fetch and run your private dotfiles install script.

---

## 🔐 How It Works

- The script uses the 1Password CLI (`op`) to retrieve secrets securely.
- You can configure your 1Password domain using the `1PASSWORD_DOMAIN` environment variable.
- GitHub tokens or SSH keys are used to access private repositories.

---

## 🛠️ Customization

You can fork and customize the following script:

- [setup.sh](https://github.com/infratron-io/setup/blob/main/setup.sh)
- Update the `INSTALL_SCRIPT_URL` in `setup.sh` if your install script lives in another location.

---

## ❓ Need Help?

Open an issue on the [infratron-io/setup](https://github.com/infratron-io/setup) repository.

---

Happy hacking! 🚀

# setup
