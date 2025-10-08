### Description

Biberon Api

## Başlarken

1- Öncelike [Node](https://nodejs.org/en)'u bilgisayarımıza kurmalıyız.

2- Repoyu cloneluyoruz.

[!IMPORTANT]

Repoyu kesinlikle forklamıyoruz. Kullanacağımız trunk based development dolayısıyla her şeyin aynı repoda olması gerekmektedir.

3- `cp .env-example .env` komutunu çalıştırıyoruz.

4- `cp docker.env.example docker.env` komutunu çalıştırıyoruz. Daha sonra ilgili yerlerdeki secretları yeni oluşan docker.env dosyasına ekliyoruz

5- `npm install` komutunu çalıştırıp paketleri indiriyoruz.

6- Daha sonra docker desktopu çalıştırıyoruz ve ardından `docker compose up --build` komutunu çalıştırıyoruz.

7- localhost:3000 adresinden api'ya ulaşıyoruz.

## Maildev

Geliştirme ortamında atılan mailler localhost:1080 adresinden ulaşılabilir olacaktır. Gerçekten ilgili adrese bir mail gönderilmeyecektir.
