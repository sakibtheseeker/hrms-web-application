<%@ Page Title="" Language="C#" MasterPageFile="~/AdminMaster.Master" AutoEventWireup="true" CodeBehind="PaySlipReports.aspx.cs" Inherits="hrms_web_application.PaySlipReports" %>
<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">
    <div class="content">

    <!-- Breadcrumb -->
    <div class="d-md-flex d-block align-items-center justify-content-between page-breadcrumb mb-3">
        <div class="my-auto mb-2">
            <h2 class="mb-1">Payslip Report</h2>
            <nav>
                <ol class="breadcrumb mb-0">
                    <li class="breadcrumb-item">
                        <a href="index.html"><i class="ti ti-smart-home"></i></a>
                    </li>
                    <li class="breadcrumb-item">
                        HR
                    </li>
                    <li class="breadcrumb-item active" aria-current="page">Payslip Report</li>
                </ol>
            </nav>
        </div>
        <div class="d-flex my-xl-auto right-content align-items-center flex-wrap ">
            <div class="mb-2">
                <div class="dropdown">
                    <a href="javascript:void(0);" class="dropdown-toggle btn btn-white d-inline-flex align-items-center" data-bs-toggle="dropdown">
                        <i class="ti ti-file-export me-1"></i>Export
                    </a>
                    <ul class="dropdown-menu  dropdown-menu-end p-3">
                        <li>
                            <a href="javascript:void(0);" class="dropdown-item rounded-1"><i class="ti ti-file-type-pdf me-1"></i>Export as PDF</a>
                        </li>
                        <li>
                            <a href="javascript:void(0);" class="dropdown-item rounded-1"><i class="ti ti-file-type-xls me-1"></i>Export as Excel </a>
                        </li>
                    </ul>
                </div>
            </div>
            <div class="head-icons ms-2">
                <a href="javascript:void(0);" class="" data-bs-toggle="tooltip" data-bs-placement="top" data-bs-original-title="Collapse" id="collapse-header">
                    <i class="ti ti-chevrons-up"></i>
                </a>
            </div>
        </div>
    </div>
    <!-- /Breadcrumb -->

    <div class="row">

        <!-- Total Exponses -->
        <div class="col-xl-6 d-flex">
            <div class="row flex-fill">
                <div class="col-md-6 d-flex">
                    <div class="card flex-fill">
                        <div class="card-body">
                            <div class="d-flex align-items-center justify-content-between bg-light border rounded p-2 mb-2">
                                <div class="">
                                    <span class="fs-14 fw-normal text-truncate mb-1">Total Payroll</span>
                                    <h5>
                                        $<asp:Label ID="Label1" runat="server" Text="0"></asp:Label>
                                    </h5>
                                </div>
                                <a href="#" class="avatar avatar-md avatar-rounded bg-transparent-primary border border-primary">
                                    <span class="text-primary"><i class="ti ti-brand-shopee"></i></span>
                                </a>
                            </div>
                            <p class="fs-12 fw-normal d-flex align-items-center text-truncate">
                                <span class="text-success fs-12 d-flex align-items-center me-1">
                                    <i class="ti ti-arrow-wave-right-up me-1"></i>+20.01% 
                                </span> from last week
                            </p>
                        </div>
                    </div>
                </div>
                <div class="col-md-6 d-flex">
                    <div class="card flex-fill">
                        <div class="card-body">
                            <div class="d-flex align-items-center justify-content-between bg-light border rounded p-2 mb-2">
                                <div class="">
                                    <span class="fs-14 fw-normal text-truncate mb-1">Deductions</span>
                                    <h5>$<asp:Label ID="Label2" runat="server" Text="0"></asp:Label></h5>
                                </div>
                                <a href="#" class="avatar avatar-md avatar-rounded bg-transparent-danger border border-danger">
                                    <span class="text-danger"><i class="ti ti-brand-shopee"></i></span>
                                </a>
                            </div>
                            <p class="fs-12 fw-normal d-flex align-items-center text-truncate">
                                <span class="text-success fs-12 d-flex align-items-center me-1">
                                    <i class="ti ti-arrow-wave-right-up me-1"></i>+17.01% 
                                </span> from last week
                            </p>
                        </div>
                    </div>
                </div>
                <div class="col-md-6 d-flex">
                    <div class="card flex-fill">
                        <div class="card-body">
                            <div class="d-flex align-items-center justify-content-between bg-light border rounded p-2 mb-2">
                                <div class="">
                                    <span class="fs-14 fw-normal text-truncate mb-1">Net Pay</span>
                                    <h5>$<asp:Label ID="Label3" runat="server" Text="0"></asp:Label></h5>
                                </div>
                                <a href="#" class="avatar avatar-md avatar-rounded bg-transparent-success border border-success">
                                    <span class="text-success"><i class="ti ti-brand-shopee"></i></span>
                                </a>
                            </div>
                            <p class="fs-12 fw-normal d-flex align-items-center text-truncate">
                                <span class="text-success fs-12 d-flex align-items-center me-1">
                                    <i class="ti ti-arrow-wave-right-up me-1"></i>+10.01% 
                                </span> from last week
                            </p>
                        </div>
                    </div>
                </div>
                <div class="col-md-6 d-flex">
                    <div class="card flex-fill">
                        <div class="card-body">
                            <div class="d-flex align-items-center justify-content-between bg-light border rounded p-2 mb-2">
                                <div class="">
                                    <span class="fs-14 fw-normal text-truncate mb-1">Earnings</span>
                                    <h5>$<asp:Label ID="Label4" runat="server" Text="0"></asp:Label></h5>
                                </div>
                                <a href="#" class="avatar avatar-md avatar-rounded bg-transparent-skyblue border border-skyblue">
                                    <span class="text-skyblue"><i class="ti ti-brand-shopee"></i></span>
                                </a>
                            </div>
                            <p class="fs-12 fw-normal d-flex align-items-center text-truncate">
                                <span class="text-danger fs-12 d-flex align-items-center me-1">
                                    <i class="ti ti-arrow-wave-right-up me-1"></i>-10.01% 
                                </span> from last week
                            </p>
                        </div>
                    </div>
                </div>
            </div>
        </div>
        <!-- /Total Exponses -->

        <!-- Payroll Chart -->
        <div class="col-xl-6 d-flex">
            <div class="card flex-fill">
                <div class="card-header border-0 pb-0">
                    <div class="d-flex flex-wrap justify-content-between align-items-center">
                        <div class="d-flex align-items-center ">
                            <span class="me-2"><i class="ti ti-chart-area-line text-danger"></i></span>
                            <h5>Payroll</h5>
                        </div>
                        <div class="dropdown">
                            <a href="javascript:void(0);" class="dropdown-toggle btn btn-sm fs-12 btn-white d-inline-flex align-items-center" data-bs-toggle="dropdown">
                                This Year
                            </a>
                            <ul class="dropdown-menu  dropdown-menu-end p-2">
                                <li>
                                    <a href="javascript:void(0);" class="dropdown-item rounded-1">2024</a>
                                </li>
                                <li>
                                    <a href="javascript:void(0);" class="dropdown-item rounded-1">2023</a>
                                </li>
                                <li>
                                    <a href="javascript:void(0);" class="dropdown-item rounded-1">2022</a>
                                </li>
                            </ul>
                        </div>
                    </div>
                </div>
                <div class="card-body py-0">
                    <div id="payslip-chart"></div>
                </div>
            </div>
        </div>
        <!-- /Payroll Chart -->

    </div>

    <!-- Payslip List -->
    <div class="card">
        <div class="card-header">

            <div class="row align-items-center mb-3">

                <div class="col-md-4 col-12 mb-2 mb-md-0">
                    <h5 class="mb-0">Payslip List</h5>
                </div>

                <div class="col-md-4 col-6 mb-2 mb-md-0">
                    <label class="form-label">Month</label>
                    <asp:DropDownList ID="DropDownList1" runat="server"
                        CssClass="form-select"
                        AutoPostBack="true"
                        OnSelectedIndexChanged="DropDownList1_SelectedIndexChanged">

                        <asp:ListItem Text="All Months" Value="" />
                        <asp:ListItem Text="Jan - March" Value="1,2,3" />
                        <asp:ListItem Text="April - June" Value="4,5,6" />
                        <asp:ListItem Text="July - Sept" Value="7,8,9" />
                        <asp:ListItem Text="Oct - Dec" Value="10,11,12" />
                    </asp:DropDownList>
                </div>

                <div class="col-md-4 col-6 mb-2 mb-md-0">
                    <label class="form-label">Sort By</label>
                    <asp:DropDownList ID="DropDownList2" runat="server"
                        CssClass="form-select"
                        AutoPostBack="true"
                        OnSelectedIndexChanged="DropDownList2_SelectedIndexChanged">

                        <asp:ListItem Text="--Select--" Value="" />
                        <asp:ListItem Text="Ascending" Value="ASC" />
                        <asp:ListItem Text="Descending" Value="DESC" />
                    </asp:DropDownList>
                </div>

            </div>

            <div class="row">
                <div class="col-md-4 ms-auto text-end">
                    <asp:TextBox ID="TextBox1" runat="server"
                        CssClass="form-control"
                        AutoPostBack="true"
                        OnTextChanged="TextBox1_TextChanged"
                        Placeholder="Search" />
                </div>
            </div>

        </div>
    </div>

    <div class="card-body p-0">
        <div class="custom-datatable-filter table-responsive">
            <asp:GridView ID="gvPayslip"
                runat="server"
                AutoGenerateColumns="false"
                CssClass="table table-bordered">

                <Columns>
                    <asp:BoundField DataField="PayslipId" HeaderText="Payslip ID" />
                    <asp:BoundField DataField="Name" HeaderText="Name" />
                    <asp:BoundField DataField="PaidAmount" HeaderText="Paid Amount" />
                    <asp:BoundField DataField="PaidMonth" HeaderText="Paid Month" />
                    <asp:BoundField DataField="PaidYear" HeaderText="Paid Year" />
                </Columns>

            </asp:GridView>
        </div>
    </div>

</div>
</asp:Content>
