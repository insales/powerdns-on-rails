# InSales fork of PowerDNS on Rails

## Деплой в продакшен через shipit

https://shipit.insales.ru/insales/powerdns-on-rails/production

## Деплой в продакшен через консоль

### Подготовка к деплою

- добавить себе в `~/.ssh/config` настройки:

```
Host powerdnsapp3.insales.ru
    hostname 10.0.3.147
    ProxyCommand ssh -W %h:%p -q deploy@h3.insales.ru
    ForwardAgent yes

Host powerdnsapp6.insales.ru
    hostname 10.0.3.148
    ProxyCommand ssh -W %h:%p -q deploy@h6.insales.ru
    ForwardAgent yes
```

- запустить ssh-agent и добавить свой приватный ключ
```sh
eval `ssh-agent -s`
ssh-add
```

### Деплой

```sh
bundle exec cap production deploy
bundle exec cap production deploy:migrate
```

### Локальная разработка

`database.yml`

Использовать для входа SSO "через google",
локально авторизация пойдет через заглушку и авторизует под `developer@insales.ru` (юзер автосоздается при входе)

Дамп прода (делать из офиса/vpn):
```sh
PGPASSWORD=.. pg_dump -Fc --host=138.201.51.2 --port=14016 --username=powerdns --exclude-table=audits powerdns > prod.dump
pg_restore --host=127.0.0.1 --port=5432 --clean --dbname=powerdns_development --username=postgres prod.dump
```

### Тесты

RSpec
