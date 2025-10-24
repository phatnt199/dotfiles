# Java LSP Setup for Neovim

This configuration provides a comprehensive Java development environment with jdtls (Eclipse JDT Language Server).

## Prerequisites

1. **Java Development Kit**: Install Java 17 or higher
   ```bash
   # Ubuntu/Debian
   sudo apt install openjdk-17-jdk

   # Or check installed versions
   ls /usr/lib/jvm/
   ```

2. **jdtls Installation**: Download and install Eclipse JDT Language Server
   ```bash
   # Set workspace environment variable (or let it default to ~/Workspace/env)
   export WORKSPACE_ENV="${HOME}/Workspace/env"
   mkdir -p "${WORKSPACE_ENV}/jdtls/latest"
   mkdir -p "${WORKSPACE_ENV}/jdtls/workspaces"

   # Download the latest jdtls
   cd "${WORKSPACE_ENV}/jdtls"
   wget https://download.eclipse.org/jdtls/milestones/1.9.0/jdt-language-server-1.9.0-202203031534.tar.gz
   tar -xzf jdt-language-server-*.tar.gz -C latest/
   rm jdt-language-server-*.tar.gz

   # Verify installation
   ls "${WORKSPACE_ENV}/jdtls/latest/plugins/"
   # Should see org.eclipse.equinox.launcher_*.jar
   ```

## Features

### Advanced Code Lens
- **Reference counts**: See how many times methods/classes are referenced
- **Decompiled sources**: View decompiled library code

### Smart Completion
- **Favorite static imports**: Quick access to common testing utilities (JUnit, Mockito, Hamcrest)
- **Filtered types**: Hides internal/deprecated packages from suggestions
- **Import organization**: Automatically organizes imports in standard order

### Code Generation
- **toString()**: Generate readable string representations
- **hashCode/equals**: Generate using Java 7+ Objects class
- **Extract refactorings**: Variable, constant, and method extraction

### Source Management
- **Auto-download sources**: Automatically fetches Maven/Eclipse sources for libraries
- **Star imports**: Avoids using star imports (threshold set to 9999)

### Testing Support
- **Run tests**: Execute JUnit tests from within Neovim
- **Test nearest**: Run the test method under cursor
- **Test class**: Run all tests in current class

## Keybindings

All Java-specific keybindings use `<leader>j` prefix:

| Keybinding | Mode | Action |
|------------|------|--------|
| `<leader>jo` | Normal | Organize imports |
| `<leader>jv` | Normal/Visual | Extract variable |
| `<leader>jc` | Normal/Visual | Extract constant |
| `<leader>jm` | Visual | Extract method |
| `<leader>ju` | Normal | Update project configuration |
| `<leader>jt` | Normal | Run test class |
| `<leader>jn` | Normal | Run nearest test method |

Standard LSP keybindings also work:
- `gd` - Go to definition
- `gr` - Find references
- `K` - Show hover documentation
- `<leader>ca` - Code actions
- `<leader>rn` - Rename symbol

## Configuration Highlights

### Multiple Java Versions
Configure different Java runtimes for different projects:

1. Edit `confs/neovim/lua/plugs/nvim-lsp-conf.lua`
2. Uncomment and configure the `configuration.runtimes` section
3. Set paths to your installed Java versions

```lua
configuration = {
    runtimes = {
        {
            name = "JavaSE-11",
            path = "/usr/lib/jvm/java-11-openjdk-amd64",
        },
        {
            name = "JavaSE-17",
            path = "/usr/lib/jvm/java-17-openjdk-amd64",
        },
        {
            name = "JavaSE-21",
            path = "/usr/lib/jvm/java-21-openjdk-amd64",
        },
    },
},
```

### Project-Specific Workspaces
Each Java project gets its own isolated workspace directory:
- Location: `$WORKSPACE_ENV/jdtls/workspaces/<project-name>/`
- Prevents conflicts between projects
- Clean separation of build artifacts and caches

### Google Java Style Formatter
The configuration uses Google's Java style guide:
- Located at: `confs/neovim/lang-servers/intellij-java-google-style.xml`
- Automatically applied on save (if configured)
- Can be customized to your team's standards

## Troubleshooting

### jdtls not starting
1. Check Java installation: `java -version`
2. Verify jdtls installation: `ls $WORKSPACE_ENV/jdtls/latest/plugins/`
3. Check Neovim logs: `:LspLog`

### Launcher JAR not found
The configuration uses `vim.fn.glob()` to find the launcher JAR automatically. If it fails:
1. Verify the JAR exists: `ls $WORKSPACE_ENV/jdtls/latest/plugins/org.eclipse.equinox.launcher_*.jar`
2. Check file permissions
3. Manually set the exact path if needed

### Workspace conflicts
If you experience issues with multiple projects:
1. Clean workspace: `rm -rf $WORKSPACE_ENV/jdtls/workspaces/<project-name>`
2. Restart Neovim
3. Let jdtls rebuild the workspace

### Performance issues
For large projects:
1. Increase JVM memory: Edit `-Xmx2g` to `-Xmx4g` or higher
2. Exclude build directories from LSP scanning
3. Use incremental builds with Maven/Gradle

## Advanced Features

### Debugging Support
To add debugging capabilities, install nvim-dap and java-debug:
```lua
-- Add to your plugins
{
    "mfussenegger/nvim-dap",
    dependencies = {
        "microsoft/java-debug",
    }
}
```

### Maven/Gradle Integration
jdtls automatically detects:
- `pom.xml` (Maven)
- `build.gradle` / `build.gradle.kts` (Gradle)
- `.gradlew` (Gradle wrapper)

### Code Lens
Enable inline information about code:
```lua
-- Already enabled in config
referencesCodeLens = { enabled = true }
```

Shows:
- Number of references to methods/classes
- Implementations of interfaces
- Test results (when debugging is configured)

## Additional Resources

- [jdtls Wiki](https://github.com/eclipse/eclipse.jdt.ls/wiki)
- [nvim-jdtls Plugin](https://github.com/mfussenegger/nvim-jdtls)
- [Google Java Style Guide](https://google.github.io/styleguide/javaguide.html)
