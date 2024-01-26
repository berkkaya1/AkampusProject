# AKAMPUS PROJESI
Projenin Amaci
- Kullanicilarin kayit olup giriş yapabileceği bir arayüz.
- Ana ekranda faturaların telefon kamerasıyla çekilmesi.
- Google OCR SDK kullanarak api istegi ile çekilen fotografın yazıya dönüştürülmesi.
- Gelen yazıdan belli başlı markaların ayıklanması ve tespit edilen marka başına kullanıcı puanına +10 eklenmesi.
- Tespit edilemeyen marka olursa pop-up ile uyarı gösterilmesi.

Kullandıgım Bazı Teknolojiler:
- Proje Programmatic UIKIT ile yazıldı ve buna gore baştan kurgulandı.
- MVC Patterni kullanılmış olup View icinde Custom Componentler hazırlanıp Controller Classlari içinde bunlar özelleştirildi ve kullanıldı.
- Google OCR servisine baglanmak gibi işlemler ayrı Classlarda ele alındı ve proje olabildiği kadar parçalara ayrıldı.
- Firebase kullanılarak Authentication işlemleri yapıldı bunun yanı sıra custom validator ile email ve password kontrolü ekstradan yapıldı.
- Kullanıcı bilgileri Firestore ile kayıt edildi.
- Gerekli olan durumlarda Protocol, Extention gibi Swift diline ozel yaklaşımlara başvuruldu.
- Kamera erişim izni gibi işlemler ele alındı.

  Ekstadan Eklediğim Özellikler:
- Seçilen fotografın anaekranda gösterilmesi.
- Galeriden fotograf seçilip bu fotografın kullanılabilmesi.


