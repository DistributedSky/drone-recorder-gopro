# Сборка контейнера Drone Recorder GoPRO
###Рекомендации:

Данный софт используется на аппаратной платформе Raspberry PI ```ARM``` и работает непосредственно с камерой GoPro. На текущий момент рекомендуется 3+ и 4 модели данной камеры.

Данный софт рекомедуется устанавливать после установки продукта Drone Master Messenger.

Для установки данного продукта необходимо наличие следующих компонентов:

- Docker 

Установка:

```Bash
curl -sSL https://get.docker.com | sh
```

- Git

Установка:

```Bash
sudo apt-get install git-core
```

Для установки данного продукта данных пакетов достаточно.

###Этапы сборки проекта:

Первоначально необходимо клонировать себе в любое удобное место файлы из репозитария:

```Bash
cd ~/
mkdir drone-recorder-gopro
git clone git@github.com:DroneEmployee/drone-recorder-gopro.git
```

И далее необходимо собрать сам контейнер в ```Docker```

```Bash
docker build -t DroneEmployee/drone-recorder-gopro:armfh .
```

Произайдет этап сборки контейнера в течении 2-3 минут.

После успешной сборки проверим состояние образа:

```Bash
docker images
REPOSITORY                             TAG                 IMAGE ID            CREATED             SIZE
droneemployee/drone-recorder-gopro     armhf               b743a3fc1560        2 minute ago        1.06GB

```

Далее необходимо обновить страницу в браузере и у вас появится возможность добавить камеру к ```drone-master-messenger```.
