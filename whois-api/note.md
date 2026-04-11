✘ dat@nuc  ~/0lab  ↱ main  curl -i -X POST \
    -H "Content-Type: application/x-www-form-urlencoded; charset=UTF-8" \
    -H "Origin: https://tracuutenmien.gov.vn" \
    -H "Referer: https://tracuutenmien.gov.vn/tra-cuu-thong-tin-ten-mien" \
    --data "domainName=genk.vn" \
    --ciphers 'DEFAULT:@SECLEVEL=1' \
    "https://tracuutenmien.gov.vn/tra-cuu-thong-tin-ten-mien"
HTTP/1.1 200 OK
Date: Sat, 11 Apr 2026 16:54:32 GMT
Transfer-Encoding: chunked
Content-Type: text/html;charset=UTF-8
Content-Language: vi-VN
Set-Cookie: BIGipServerTRACUUTENMIEN.app~TRACUUTENMIEN_pool=rd2o00000000000000000000ffffcb774b29o7780; path=/; Httponly; Secure
Vary: Accept-Encoding

<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml" lang="vi">

<head>
        <head>

                <meta charset="utf-8">
                <meta http-equiv="X-UA-Compatible" content="IE=edge">
                <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
                <meta property="og:type" content="website">
                <meta property="og:image" content="https://vnnic.vn/sites/all/themes/vnnic_new/css/images/logo.png">
                <meta property="og:url" content="">
                <meta property="og:title" content="Cổng tra cứu thông tin tên miền">
                <meta property="og:description" content="Cổng tra cứu thông tin tên miền">
                <title>Cổng tra cứu thông tin tên miền</title>
                <link rel="shortcut icon" href="/themes/img/logo-bo.png">
                <link href="/plugins/bootstrap/css/bootstrap.min.css"
                        rel="stylesheet">
                <link href="/plugins/fontawesome-free/css/all.min.css"
                        rel="stylesheet">
                <link href="/themes/css/styles.css" rel="stylesheet">

</head>
</head>

<body>
        <div class="d-flex flex-column h-100">
                <header id="header-bar" class="site__header">
                        <header id="header-bar" class="site__header">
                <div class="header-top">
                        <div class="container h-100 d-flex align-items-center">
                                <img class="hero-logo" src="themes/img/quoc-huy.svg" alt="logo-bo">
                                <div class="hero-title">
                                        <div class="hero-title1">BỘ KHOA HỌC VÀ CÔNG NGHỆ</div>
                                        <div class="hero-title2">MINISTRY OF SCIENCE AND TECHNOLOGY</div>
                                </div>
                        </div>
                </div>
        </header>
                        <div class="header-search">
                                <div class="container h-100">
                                        <div class="row d-flex flex-column align-items-center">
                                                <div class="header-search__title">HỆ THỐNG THÔNG TIN TRA CỨU TÊN MIỀN</div>
                                                <!-- <div class="header-search__slogan"></div> -->
                                                <form id="header-search__search-bar" class="col-lg-6" action="/tra-cuu-thong-tin-ten-mien" method="POST">
                                                        <div class="input-group mb-3">
                                                                <i class="fas fa-search"></i>
                                                                <input type="text" class="form-control" placeholder="Vui lòng nhập tên miền"
                                                                        name="domainName" aria-describedby="submit-domain" required>
                                                                <div class="input-group-append">
                                                                <button type="submit" id="submit-domain" class="g-recaptcha input-group-text" data-sitekey="6LclM4IkAAAAAFHdMphAX1z7RATzPZvAQNZdNmQa" data-callback='onSubmit' data-action='submit'>TÌM KIẾM</button>
                                                                </div>
                                                        </div>

                                                </form>
                                                <script>
                                                  function onSubmit(token) {
                                                        document.getElementById("header-search__search-bar").submit();
                                                  }
                                                </script>
                                        </div>
                                </div>
                        </div>
                </header>
                <!--Main body-->
                <div class="body-container__page">
                        <div class="wrapper h-100">
                                <!--Main content-->
                                <div class="container h-100">
                                        <div class="domain-info-section">
                                                <div class="card my-5">
                                                        <div class="card-header">
                                                                <div class="card-title">THÔNG TIN TRA CỨU</div>
                                                        </div>
                                                        <!--Hien thi neu ten mien la ten mien tieng viet-->
                                                        <div class="card-body">
                                                                <h5 class="card-text">genk.vn</h5>
                                                                <table class="table">
                                                                        <tbody>
                                                                                <tr>
                                                                                        <td>Loại tên miền:</td>
                                                                                        <td>Tên miền quốc gia .VN</td>
                                                                                </tr>

                                                                                        <tr>
                                                                                                <td>Tên chủ thể đăng ký sử dụng:</td>
                                                                                                <td>CÔNG TY TNHH NỘI DUNG SỐ PEGA</td>
                                                                                        </tr>
                                                                                        <tr>
                                                                                                <td>Nhà đăng ký quản lý:</td>
                                                                                                <td>
                                                                                                        <a href="https://www.vnnic.vn/nhadangky/thongtin/c%C3%B4ng-ty-c%E1%BB%95-ph%E1%BA%A7n-gmo-zcom-runsystem">Công ty Cổ phần GMO-Z.com RUNSYSTEM</a>

                                                                                                </td>
                                                                                        </tr>
                                                                                        <tr>
                                                                                                <td>Ngày đăng ký:</td>
                                                                                                <td>30-11-2010</td>
                                                                                        </tr>
                                                                                        <tr>
                                                                                                <td>Ngày hết hạn:</td>
                                                                                                <td>30-11-2028</td>
                                                                                        </tr>


                                                                        </tbody>
                                                                </table>
                                                        </div>
                                                        <!--Hien thi neu ten mien la ten mien quoc te-->

                                                </div>
                                        </div>
                                </div>
                                <!--./Main content-->
                        </div>
                </div>

                <!--./Main body-->


                <footer id="footer-container">
                <div class="container h-100">
                        <div class="row">
                                <div class="col-xl-3 d-flex  align-items-center justify-content-center">
                                        <img id="logo-vnnic" class="me-xl-auto" src="/themes/img/logo-vnnic.svg"
                                                alt="">
                                </div>
                                <div class="col-xl-6 d-flex align-items-center justify-content-center">
                                        <div class="footer-info-container">
                                                <div class="footer-title mb-1">Hệ thống tra cứu thông tin tên miền</div>
                                                <div class="footer-description">
                                                        Phát triển bởi Trung tâm Internet Việt Nam - Bộ Khoa học và Công nghệ</div>
                                                <div class="footer-info">
                                                        Địa chỉ: <b>18 Nguyễn Du, Hà Nội</b>
                                                </div>
                                                <div class="footer-info">
                                                        Điện thoại: <b>+84-24-35564944</b>
                                                </div>
                                                <div class="footer-info">
                                                        Email: <a class="orange-link" href="mailto:domain-support@vnnic.vn" target="_blank"><b>domain-support@vnnic.vn</b></a>
                                                </div>
                                        </div>
                                </div>
                                <div class="col-xl-3 d-flex align-items-center justify-content-center">
                                        <div class="footer-right ms-xl-auto d-flex flex-column">
                                                <div class="footer-icon-list d-flex my-2 flex-row-reverse">
                                                        <a href="https://www.facebook.com/myVNNIC/" target="_blank">
                                                                <img src="/themes/img/footer-icons/fb-icon.svg"
                                                                        alt="">
                                                        </a>
                                                        <a href="https://www.youtube.com/channel/UCLvuvINvucsfLAPrasmz9Cw" target="_blank">
                                                                <img src="/themes/img/footer-icons/youtube-icon.svg"
                                                                        alt="">
                                                        </a>
                                                        <a href="mailto:domain-support@vnnic.vn" target="_blank">
                                                                <img src="/themes/img/footer-icons/mail-icon.svg"
                                                                        alt="">
                                                        </a>
                                                        <a href="https://www.vnnic.vn/lienhe" target="_blank">
                                                                <img src="/themes/img/footer-icons/location-icon.svg"
                                                                        alt="">
                                                        </a>
                                                </div>
                                                <div class="footer-copyright">Bản quyền &#169; 2023 VNNIC.</div>
                                        </div>
                                </div>
                        </div>
                </div>
        </footer>
        </div>
        <!--Scripts-->

                <script src="/plugins/bootstrap/js/bootstrap.min.js"></script>
                <!-- Google reCAPTCHA -->
                <script src="https://www.google.com/recaptcha/api.js"></script>

                <!--Validate-->


        <script>
                if (window.history.replaceState) {
                        window.history.replaceState(null, null, window.location.href);
                }
        </script>
</body>

</html>%                                                      