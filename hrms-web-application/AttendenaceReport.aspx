<%@ Page Title="" Language="C#" MasterPageFile="~/AdminMaster.Master" AutoEventWireup="true" CodeBehind="AttendenaceReport.aspx.cs" Inherits="hrms_web_application.AttendenaceReport" %>
<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">
    <div class="content">

    <!-- Breadcrumb -->
    <div class="d-md-flex d-block align-items-center justify-content-between page-breadcrumb mb-3">
        <div class="my-auto mb-2">
            <h2 class="mb-1">Attendance Report</h2>
            <nav>
                <ol class="breadcrumb mb-0">
                    <li class="breadcrumb-item">
                        <a href="index.html"><i class="ti ti-smart-home"></i></a>
                    </li>
                    <li class="breadcrumb-item">HR</li>
                    <li class="breadcrumb-item active" aria-current="page">Attendance Report</li>
                </ol>
            </nav>
        </div>
        <div class="d-flex my-xl-auto right-content align-items-center flex-wrap">
            <div class="mb-2">
                <div class="dropdown">
                    <a href="javascript:void(0);" class="dropdown-toggle btn btn-white d-inline-flex align-items-center" data-bs-toggle="dropdown">
                        <i class="ti ti-file-export me-1"></i>Export
                    </a>
                    <ul class="dropdown-menu dropdown-menu-end p-3">
                        <li>
                            <a class="dropdown-item rounded-1" href="/AttendanceReport/ExportToPdf"><i class="ti ti-file-type-pdf me-1"></i>Export as PDF</a>
                        </li>
                        <li>
                            <a class="dropdown-item rounded-1" href="/AttendanceReport/ExportToExcel"><i class="ti ti-file-type-xls me-1"></i>Export as Excel</a>
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
        <div class="col-xl-6 d-flex">
            <div class="row flex-fill">
                <!-- Total Working Days -->
                <div class="col-lg-6 col-md-6 d-flex">
                    <div class="card flex-fill">
                        <div class="card-body">
                            <div class="d-flex align-items-center overflow-hidden mb-2">
                                <div class="attendence-icon"><span><i class="ti ti-calendar text-primary"></i></span></div>
                                <div class="ms-2 overflow-hidden">
                                    <p class="fs-12 fw-normal mb-1 text-truncate">Total Working Days</p>
                                    <h4><asp:Label ID="Label1" runat="server" Text="0"></asp:Label></h4>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>

                <!-- Total Leaves Taken -->
                <div class="col-lg-6 col-md-6 d-flex">
                    <div class="card flex-fill">
                        <div class="card-body">
                            <div class="d-flex align-items-center overflow-hidden mb-2">
                                <div class="attendence-icon"><span><i class="ti ti-calendar text-info"></i></span></div>
                                <div class="ms-2 overflow-hidden">
                                    <p class="fs-12 fw-normal mb-1 text-truncate">Total Leave Taken</p>
                                    <h4><asp:Label ID="Label2" runat="server" Text="0"></asp:Label></h4>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>

                <!-- Total Holidays -->
                <div class="col-lg-6 col-md-6 d-flex">
                    <div class="card flex-fill">
                        <div class="card-body">
                            <div class="d-flex align-items-center overflow-hidden mb-2">
                                <div class="attendence-icon"><span><i class="ti ti-calendar text-pink"></i></span></div>
                                <div class="ms-2 overflow-hidden">
                                    <p class="fs-12 fw-normal mb-1 text-truncate">Total Holidays</p>
                                    <h4><asp:Label ID="Label3" runat="server" Text="0"></asp:Label></h4>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>

                <!-- Total Halfdays -->
                <div class="col-lg-6 col-md-6 d-flex">
                    <div class="card flex-fill">
                        <div class="card-body">
                            <div class="d-flex align-items-center overflow-hidden mb-2">
                                <div class="attendence-icon"><span><i class="ti ti-calendar text-warning"></i></span></div>
                                <div class="ms-2 overflow-hidden">
                                    <p class="fs-12 fw-normal mb-1 text-truncate">Total Halfdays</p>
                                    <h4><asp:Label ID="Label4" runat="server" Text="0"></asp:Label></h4>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>

            </div>
        </div>

        <!-- Chart -->
        <div class="col-xl-6">
            <div class="card">
                <div class="card-header border-0 pb-0">
                    <div class="d-flex flex-wrap justify-content-between align-items-center">
                        <div class="d-flex align-items-center">
                            <span class="me-2"><i class="ti ti-chart-line text-danger"></i></span>
                            <h5>Attendance</h5>
                        </div>
                    </div>
                </div>
                <div class="card-body py-0 px-2">
                    <div id="attendance-report"></div>
                </div>
            </div>
        </div>
    </div>

    <!-- Filters -->
    <div class="card">
        <div class="card-body">
            <div class="row mb-3">
                <!-- Date Filter -->
                <div class="col-md-4">
                    <label>Select Date Filter:</label>
                    <asp:DropDownList ID="DropDownList1" runat="server" CssClass="form-control" AutoPostBack="true" OnSelectedIndexChanged="DropDownList1_SelectedIndexChanged">
                        <asp:ListItem Text="--Select Date Filter--" Value=""></asp:ListItem>
                        <asp:ListItem Text="Yesterday" Value="yesterday"></asp:ListItem>
                        <asp:ListItem Text="Last 7 Days" Value="last7days"></asp:ListItem>
                        <asp:ListItem Text="Last 30 Days" Value="last30days"></asp:ListItem>
                        <asp:ListItem Text="Last Year" Value="lastYear"></asp:ListItem>
                        <asp:ListItem Text="This Year" Value="thisYear"></asp:ListItem>
                    </asp:DropDownList>
                </div>

                <!-- Status Filter -->
                <div class="col-md-4">
                    <label>Select Status:</label>
                    <asp:DropDownList ID="DropDownList2" runat="server" CssClass="form-control" AutoPostBack="true" OnSelectedIndexChanged="DropDownList2_SelectedIndexChanged">
                        <asp:ListItem Text="--Select Status--" Value=""></asp:ListItem>
                        <asp:ListItem Text="Present" Value="Present"></asp:ListItem>
                        <asp:ListItem Text="Absent" Value="Absent"></asp:ListItem>
                        <asp:ListItem Text="Half Day" Value="Half Day"></asp:ListItem>
                    </asp:DropDownList>
                </div>

                <!-- Sort -->
                <div class="col-md-4">
                    <label>Sort By:</label>
                    <asp:DropDownList ID="DropDownList3" runat="server" CssClass="form-control" AutoPostBack="true" OnSelectedIndexChanged="DropDownList3_SelectedIndexChanged">
                        <asp:ListItem Text="--Select--" Value=""></asp:ListItem>
                        <asp:ListItem Text="Ascending" Value="ASC"></asp:ListItem>
                        <asp:ListItem Text="Descending" Value="DESC"></asp:ListItem>
                    </asp:DropDownList>
                </div>
            </div>

            <!-- Search -->
            <div class="row mb-3">
                <div class="col-md-8"></div>
                <div class="col-md-4 text-end">
                    <asp:TextBox ID="TextBox1" runat="server" CssClass="form-control" Placeholder="Search Employee" AutoPostBack="true" OnTextChanged="TextBox1_TextChanged"></asp:TextBox>
                </div>
            </div>
        </div>
    </div>

    <!-- Grid -->
    <div class="card-body p-0">
        <div class="table-responsive" style="overflow-x:auto;">
            <asp:GridView ID="GridView1" runat="server" AutoGenerateColumns="false" CssClass="table table-bordered" HeaderStyle-CssClass="thead-light" Style="min-width:1400px;">
                <Columns>
                    <asp:BoundField DataField="AttendanceId" HeaderText="AttendanceId" />
                    <asp:TemplateField HeaderText="Employee">
                        <ItemTemplate>
                            <strong><%# Eval("Employee") %></strong>
                        </ItemTemplate>
                    </asp:TemplateField>
                    <asp:BoundField DataField="Date" HeaderText="Date" DataFormatString="{0:dd-MM-yyyy}" />
                    <asp:BoundField DataField="CheckIn" HeaderText="Check-In" />
                    <asp:BoundField DataField="CheckOut" HeaderText="Check-Out" />
                    <asp:BoundField DataField="LunchIn" HeaderText="Lunch In" />
                    <asp:BoundField DataField="LunchOut" HeaderText="Lunch Out" />
                    <asp:TemplateField HeaderText="Status">
                        <ItemTemplate>
                            <span class='badge <%# Eval("Status").ToString()=="Present" ? "badge-success" : "badge-danger" %> badge-xs'>
                                <i class="ti ti-point-filled me-1"></i>
                                <%# Eval("Status") %>
                            </span>
                        </ItemTemplate>
                    </asp:TemplateField>
                    <asp:BoundField DataField="WorkingHours" HeaderText="Working Hours" />
                    <asp:BoundField DataField="OvertimeHours" HeaderText="Overtime Hours" />
                    <asp:BoundField DataField="BreakHours" HeaderText="Break Hours" />
                    <asp:BoundField DataField="Late" HeaderText="Late" />
                    <asp:BoundField DataField="ProductionHours" HeaderText="Production Hours" />
                </Columns>
            </asp:GridView>
        </div>
    </div>

</div>
</asp:Content>
