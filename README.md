
## 安装

```bash
dart pub global activate --source git https://github.com/josercc/dcm.git
```

## 怎么使用

### 安装一个命令

比如安装`dcm`

```bash
dcm install -p https://github.com/josercc/dcm.git@main
```

### 运行一个命令

```bash
dcm run -n dcm@main
```

### 列出目前已经安装命令列表

```bash
dcm list
```

### 卸载一个已经存在的命令
```bash
dcm uninstall -n dcm@main
```

### 通过一个模版地址创建一个模板工程
```bash
dcm create -u [Git 仓库地址] -r [分支/版本/提交] -n [名称] [-d [描述]]
```
