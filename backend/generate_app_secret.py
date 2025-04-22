import secrets
import string
import os
from pathlib import Path

def generate_app_secret(length=48):
    """Generate a cryptographically secure random string for use as an app secret."""
    # Define character sets
    # Consider if you *really* need all these special characters. 
    # A slightly smaller set might reduce potential issues.
    alphabet = string.ascii_letters + string.digits + "!@#$%^&*()-_=+[]{}|;:,.<>?" 
    
    # Generate secure random string
    app_secret = ''.join(secrets.choice(alphabet) for _ in range(length))
    
    return app_secret

def update_env_file(app_secret):
    """Update or create .env file with the app secret, ensuring the value is quoted."""
    env_path = Path('.env')
    
    # Format the line with quotes around the secret
    secret_line = f'APP_SECRET="{app_secret}"\n' 
    
    # If .env exists, read its contents
    if env_path.exists():
        with open(env_path, 'r') as f:
            lines = f.readlines()
        
        # Check if APP_SECRET already exists
        app_secret_exists = False
        for i, line in enumerate(lines):
            # Use startswith to find the key, ignore existing quotes/value
            if line.strip().startswith('APP_SECRET='): 
                lines[i] = secret_line # Replace the entire line
                app_secret_exists = True
                break
        
        # If APP_SECRET doesn't exist, add it
        if not app_secret_exists:
            # Ensure there's a newline before adding if the file isn't empty
            # and doesn't end with a newline
            if lines and not lines[-1].endswith('\n'):
                lines.append('\n') 
            lines.append(secret_line)
        
        # Write updated contents back to .env
        with open(env_path, 'w') as f:
            f.writelines(lines)
    else:
        # Create new .env file with APP_SECRET
        with open(env_path, 'w') as f:
            f.write(secret_line) # Write the quoted line

if __name__ == "__main__":
    # Generate app secret
    app_secret = generate_app_secret()
    
    # Update .env file
    update_env_file(app_secret)
    
    print(f"Generated new app secret and updated .env file.")
    # Print the value as it would appear *inside* the quotes for clarity
    print(f"APP_SECRET value: {app_secret}") 
    print(f"The line in .env will look like: APP_SECRET=\"{app_secret}\"")
    print("\nMake sure to save this secret securely, as you'll need it in your iOS app.")