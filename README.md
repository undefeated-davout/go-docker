# 使い方

## Dockerコマンド

### 以下、cloneしたディレクトリ直下にてコマンド実行

```$xslt
docker-compose build
```

#### 実行

```$xslt
docker-compose up -d
```

#### コンテナ内へログイン

```$xslt
docker exec -it go-docker.app /bin/bash --login
```

### 設定

#### launch.json

```$xslt
{
    "version": "0.2.0",
    "configurations": [
        {
            "name": "Launch Server",
            "type": "go",
            "request": "launch",
            "mode": "debug",
            "program": "${workspaceFolder}/"
        }
   ]
}
```

#### settings.json

```$xslt
{
    "remote.extensionKind": {
        "ms-azuretools.vscode-docker": "workspace"
    },
    "[go]": {
        "editor.tabSize": 4,
        "editor.insertSpaces": false,
        "editor.formatOnSave": true,
        "editor.formatOnPaste": false,
        "editor.formatOnType": false
    },
    "go.formatTool": "goimports",
    "go.formatFlags": [
        "-w"
    ],
    "go.lintTool": "golangci-lint",
    "go.lintOnSave": "package",
    "go.lintFlags": [
        "--disable-all",
        "--enable=errcheck",
        "--config=${workspaceFolder}/.golangci.yml",
    ],
    "go.vetOnSave": "package",
    "go.buildOnSave": "package",
    "go.testOnSave": false,
    "go.gocodeAutoBuild": true,
    "go.installDependenciesWhenBuilding": true
}
```
