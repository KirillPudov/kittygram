# Наполнение репозитория
## Terraform
`infra` - Папка с terraform скриптами для развертывания проекта

### Пример terraform.tfvars
```
YANDEX_TOKEN = ""
YANDEX_CLOUD_ID = ""
YANDEX_FOLDER_ID = ""
YANDEX_ZONE = ""
ACCESS_KEY = ""
SECRET_KEY = ""
PUB_SSH_KEY = ""
```

## Github Workflow
`.github/workflows` - папка workflow

`terraform.yml` - Workflow для развёртывания workflow

`main.yml` - Основной workflow

В `main.yml` происходит вызов `terraform.yml` workflow для создания, удаления и плана инфраструктуры

# Результат
### Результат работы можно посмотреть на ВМ с адресом, который можно найти в шаге `terraform.yml` с ID = `apply`