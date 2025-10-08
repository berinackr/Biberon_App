# Biberon

## Başlarken

1. Öncelike hem Android Studio'yu hem de Flutter'ı sorun yaşamamak en son için sürümüne güncellemeliyiz.

   a-) Android Studio'nun son sürümlerindeki bazı önemli değişikliklerden dolayı uygulama içinden değil de tamamen Studio'yu kaldırıp baştan kurulum yapmayı öneriyoruz. [İndirme Linki](https://developer.android.com/studio)

   b-) Flutter için terminalde `flutter upgrade` komutunu çalıştırıyoruz.

2. Repoyu cloneluyoruz.

   [!IMPORTANT]
   Repoyu kesinlikle forklamıyoruz. Kullanacağımız trunk based development dolayısıyla her şeyin aynı repoda olması gerekmektedir

3. Projeyi çalıştırmadan önce gerekli secretları oluşturmalıyız.

   a-) .env-var klasörünü de projenin ana dizinine koyuyoruz.

   b-) my-key dosyalarını android/app dizinine koyuyoruz

4. Backendi [şu](https://github.com/av-erencelik/biberon-api) linkteki adımlarla cloneluyoruz ve ardından çalıştırıyoruz

5. Daha sonrasında artık projemizi çalıştırabiliriz.

   a-) Öncelikle backend kısmını yukarıdaki linkteki repodaki adımlarla çalıştırıyoruz.

   b-) Daha sonra android studio'dan emulatorü çalıştırıyoruz ve ardından vs code'da editördeki run and debug sekmesinden development buildini çalıştırıyoruz ve ardından emulatörde uygulama çalışıyor halde olucaktır.

## Katkıda Bulunma

1.  Genel işleyiş

    a-) Amaç olabildiğince [Git Flow](https://medium.com/software-development-turkey/git-flow-kullan%C4%B1m%C4%B1-ve-branch-y%C3%B6netimi-3a66a6106ddc)'dan uzaklaşıp olabildiğinde [Trunk Based Flow](https://trunkbaseddevelopment.com/)'a yakın bir şekilde çalışmak. Takımımız büyük değil o sebeple tek bir ana branch ve kısa süreli branchlerden oluşacak bir akışımız olucak

    b-) Kimse main branchine push yapamayacak (kural olarak eklendi). Herkes aldığı jira görevi için SADECE O GÖREVE has bir branch oluşturacak localinde. Görevi bitirdiğinde branchi github reposuna pushlayacak ve oradan main branchine bir pr oluşturacak. Branchlerin isimleri şu formatta olmalıdır [jira görev ismi(çok uzunsa daha kısaltılarak da yazılabilir) - jira görev kodu]

    c-) Commit düzenleriniz aşağıdaki gibi olacak. Oluşturduğumuz prların title kısmı da buna uygun olmalıdır:

          - feat: A new feature
          - fix: A bug fix
          - docs: Documentation only changes
          - style: Changes that do not affect the meaning of the code (white-space, formatting, missing semi-colons, etc)
          - refactor: A code change that neither fixes a bug nor adds a feature
          - perf: A code change that improves performance
          - test: Adding missing tests or correcting existing tests
          - build: Changes that affect the build system or external dependencies (example scopes: gulp, broccoli, npm)
          - ci: Changes to our CI configuration files and scripts (example scopes: Travis, Circle, BrowserStack, SauceLabs)
          - chore: Other changes that don't modify src or test files
          - revert: Reverts a previous commit

          Pr title'ının sonuna da ilgili jira görevinin kodunu parentez içinde koyarsak review yaparken işler kolaylaşır: (BV2-172) gibi

    d-) İlgili pr mergelendikten sonra githubtaki branch otomatik olarak silinecektir. Buna uygun olarak localinizde de main branchine geçtikten sonra ilgili eski branchi silebilirsiniz. Kesinlikle iki görev için aynı branchi kullanmıyoruz.

    f-) Pr mergelendi ve yeni aldığımız görev için yeni bir branch oluşturucaksak öncelikle main branchine geçip `git pull` komutuyla main branchinin güncel halini çekip daha sonrasında MAIN branchindeyken yeni bir branch oluşturuyoruz.

    `git checkout -b example branch`

    e-) Localde çok fazla commit atıyorsanız bunu pushlamadan önce tek bir commite birleştirip öyle pushlayabilirsiniz.

         `
         // başlamadan önce git commitlemediğimiz bir değişiklik olmamalı
         git log --oneline
         // çıkmak için q tuşuna basın
         // localde birleştirmek istediğimiz önceki commit sayısını buluyoruz
         git reset --soft HEAD~3 // son üç commit için
         // artık yeni commiti yukardaki commit düzenine uygun atabiliriz.
         git commit -m "feat: yaptık bir şeyler"
         `

## S.S.S

1-) Diyelim ki bir PR açtık ancak sonrasında bir şeyi eklemeyi ya da düzeltmeyi unuttuğumuzu farkettik ya da review sürecinde bir şey eksik bulundu bu durumda commit history'sini kirletmeden nasıl düzeltebiliriz?

Öncelikle localde düzeltmeleri yaptık şimdi yeni değişiklikleri pushlamamız gerekiyor. Sırayla şöyle yapıyoruz

      `
      git add .
      git commit --amend --no-edit
      git push origin <branch-name> --force
      `

böylelikle yeni commit atmadan değişiklikleri githubtaki açık prımıza direkt pushlayabiliyoruz.
