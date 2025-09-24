```bash
docker build -f v4-all-libs.Dockerfile -t progr000/php-5.3.29-all-libs .
docker run -it -p 280:80 --name crm-test-php53 progr000/php-5.3.29-all-libs
docker push progr000/php-5.3.29-all-libs
docker save -o /home/progr/docker-image___php-5.3.29-all-libs.tar progr000/php-5.3.29-all-libs

docker build -f v3-for-crm.Dockerfile -t progr000/php-5.3.29-base-libs .
docker run -it -p 280:80 --name crm-test-php53 progr000/php-5.3.29-base-libs
docker push progr000/php-5.3.29-base-libs
docker save -o /home/progr/docker-image___php-5.3.29-base-libs.tar progr000/php-5.3.29-base-libs
```

Чтобы сохранить Docker-образ локально в виде tar-архива, используйте команду docker save, например: 
```bash
docker save -o images.tar my-image:latest
```
Этот tar-файл можно будет загрузить обратно в Docker с помощью команды docker load. 
Для сохранения образа в удаленном реестре, например, на Docker Hub, 
используйте команды `docker build -t`, `docker login` и `docker push`.
Сохранение образа в tar-архив
Это основной способ сохранить образ на ваш локальный компьютер или передать его кому-то другому в виде единого файла.
Проверьте список ваших локальных образов, чтобы убедиться, что нужный образ существует:
```bash
docker images
```

Сохраните образ в tar-архив с помощью команды docker save:
```bash
docker save -o <имя_файла>.tar <имя_образа>:<тег>
```
`-o или --output указывает, куда сохранить файл.`

<имя_образа>:<тег> — это имя и тег вашего образа, например, my-app:v1.0.
Вы можете сохранить несколько образов в один tar-файл, указав их через пробел.
Пример:
```bash
docker save -o my_app_image.tar my-app:latest
```
В текущей папке появится файл my_app_image.tar, содержащий ваш образ.
Загрузка образа из tar-архива

Для загрузки ранее сохраненного tar-архива в Docker используйте команду docker load:
```bash
docker load -i <имя_файла>.tar
```
`-i или --input указывает, какой файл загружать.`

Загрузка образа в Docker Hub
Если вы хотите сохранить образ в удаленный репозиторий, чтобы иметь к нему доступ с других машин или поделиться им:
Соберите образ с тегом, включающим имя вашего пользователя Docker Hub (например, your-username/my-image:latest):
```bash
docker build -t your-username/my-image:latest .
```

Войдите в свой аккаунт Docker Hub в терминале:
```bash
docker login
```

Загрузите собранный образ в Docker Hub:
```bash
docker push your-username/my-image:latest
```


Clear all images
```shell
docker builder prune
```


Docker HOST network:
- https://forums.docker.com/t/getting-real-ip-inside-container/17337/7
- https://stackoverflow.com/questions/62671411/docker-get-clients-ip-address-in-container


### Build docker for crm without docker-compose:
1. You need start docker for mysql before with network = host (--net host)
2. docker build -f build-apache-php.Dockerfile -t progr000/crm-test .
3. docker rm ttt1
4. docker run -it --net host --name ttt1 --env-file ./.env-for_build-apache-php.Dockerfile_.env progr000/crm-test
 