
## 安装

```bash
sh -c "$(curl -fsSL https://raw.githubusercontent.com/josercc/dcm/main/install.sh)"
```

## 怎么使用

### 安装一个命令

比如安装`dcm`

```bash
dcm install -p https://github.com/josercc/dcm.git@main
```

### 通过一个本地项目安装（不需要.git）

```bash
dcm local -p xxxxx/dcm 
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

### 查看本地数据路径
```bash
dcm print_db_path
```