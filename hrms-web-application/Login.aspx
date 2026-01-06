<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="Login.aspx.cs" Inherits="hrms_web_application.Login" %>


<!DOCTYPE html>
<html lang="en">
<head runat="server">
    <meta charset="utf-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>Login - Pulse360</title>

    <!-- CSS (EXACT SAME AS login.html) -->
    <link rel="shortcut icon" type="image/x-icon" href="assets/img/favicon.png" />
    <link rel="apple-touch-icon" sizes="180x180" href="assets/img/apple-touch-icon.png" />

    <link rel="stylesheet" href="assets/css/bootstrap.min.css" />
    <link rel="stylesheet" href="assets/plugins/icons/feather/feather.css" />
    <link rel="stylesheet" href="assets/plugins/tabler-icons/tabler-icons.css" />
    <link rel="stylesheet" href="assets/plugins/fontawesome/css/fontawesome.min.css" />
    <link rel="stylesheet" href="assets/plugins/fontawesome/css/all.min.css" />
    <link rel="stylesheet" href="assets/css/style.css" />
</head>

<body class="bg-white">

<form id="form1" runat="server">

    <div class="main-wrapper">
        <div class="container-fuild">
            <div class="w-100 overflow-hidden position-relative flex-wrap d-block vh-100">
                <div class="row">

                    <!-- LEFT IMAGE SECTION -->
                    <div class="col-lg-5 d-none d-lg-block">
                        <div class="login-background position-relative d-flex align-items-center justify-content-center vh-100">
                            <div class="bg-overlay-img">
                                <img src="assets/img/bg/bg-01.png" class="bg-1" alt="">
                                <img src="assets/img/bg/bg-02.png" class="bg-2" alt="">
                                <img src="assets/img/bg/bg-03.png" class="bg-3" alt="">
                            </div>
                            <div class="authentication-card w-100">
                                <div class="authen-overlay-item border w-100">
                                    <h1 class="text-white display-1">
                                        Empowering people <br />
                                        through seamless HR <br />
                                        management.
                                    </h1>
                                </div>
                            </div>
                        </div>
                    </div>

                    <!-- LOGIN FORM -->
                    <div class="col-lg-7 col-md-12">
                        <div class="row justify-content-center align-items-center vh-100">
                            <div class="col-md-7">

                                <div class="vh-100 d-flex flex-column justify-content-between p-4 pb-0">

                                    <div class="mx-auto mb-5 text-center">
                                        <img src="assets/img/logo.svg" class="img-fluid" alt="Logo" />
                                    </div>

                                    <div>
                                        <div class="text-center mb-3">
                                            <h2>Sign In</h2>
                                            <p>Please enter your details to sign in</p>
                                        </div>

                                        <!-- EMAIL -->
                                        <div class="mb-3">
                                            <label class="form-label">Email Address</label>
                                            <div class="input-group">
                                                <asp:TextBox ID="txtEmail" runat="server"
                                                    CssClass="form-control border-end-0" />
                                                <span class="input-group-text border-start-0">
                                                    <i class="ti ti-mail"></i>
                                                </span>
                                            </div>
                                        </div>

                                        <!-- PASSWORD -->
                                        <div class="mb-3">
                                            <label class="form-label">Password</label>
                                            <div class="pass-group">
                                                <asp:TextBox ID="txtPassword" runat="server"
                                                    TextMode="Password"
                                                    CssClass="form-control pass-input" />
                                                <span class="ti toggle-password ti-eye-off"></span>
                                            </div>
                                        </div>

                                        <!-- LOGIN BUTTON -->
                                        <div class="mb-3">
                                            <asp:Button ID="btnLogin"
                                                runat="server"
                                                Text="Sign In"
                                                CssClass="btn btn-primary w-100"
                                                OnClick="btnLogin_Click" />
                                        </div>

                                        <div class="login-or">
                                            <span class="span-or">Or</span>
                                        </div>

                                        <!-- GOOGLE LOGIN -->
                                        <div class="mt-2 text-center">
                                            <asp:Button ID="btnGoogle"
                                                runat="server"
                                                CssClass="btn btn-outline-light border"
                                                Text="Sign in with Google"
                                                OnClick="GoogleLogin_Click" />
                                        </div>

                                    </div>

                                    <div class="mt-5 pb-4 text-center">
                                        <p class="mb-0 text-gray-9">
                                            Copyright © 2024 - Pulse360
                                        </p>
                                    </div>

                                </div>

                            </div>
                        </div>
                    </div>

                </div>
            </div>
        </div>
    </div>

</form>

<!-- JS (EXACT SAME AS login.html) -->
<script src="assets/js/jquery-3.7.1.min.js"></script>
<script src="assets/js/bootstrap.bundle.min.js"></script>
<script src="assets/js/feather.min.js"></script>
<script src="assets/js/script.js"></script>

</body>
</html>


