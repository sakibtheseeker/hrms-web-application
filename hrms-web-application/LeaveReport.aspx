<%@ Page Title="" Language="C#" MasterPageFile="~/AdminMaster.Master" AutoEventWireup="true" CodeBehind="LeaveReport.aspx.cs" Inherits="hrms_web_application.LeaveReport" %>
<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">
    <div class="content">

    <!-- Breadcrumb -->
    <div class="d-md-flex d-block align-items-center justify-content-between page-breadcrumb mb-3">
        <div class="my-auto mb-2">
            <h2 class="mb-1">Leave Report</h2>
            <nav>
                <ol class="breadcrumb mb-0">
                    <li class="breadcrumb-item">
                        <a href="index.html"><i class="ti ti-smart-home"></i></a>
                    </li>
                    <li class="breadcrumb-item">
                        HR
                    </li>
                    <li class="breadcrumb-item active" aria-current="page">Leave Report</li>
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
                            <a class="dropdown-item rounded-1" href="/LeaveReport/ExportToPdf"><i class="ti ti-file-type-pdf me-1"></i>Export as PDF</a>
                        </li>
                        <li>
                            <a class="dropdown-item rounded-1" href="/LeaveReport/ExportToExcel"><i class="ti ti-file-type-xls me-1"></i>Export as Excel</a>
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
                <!-- Total Leaves -->
                <div class="col-lg-6 col-md-6 d-flex">
                    <div class="card flex-fill">
                        <div class="card-body">
                            <div class="d-flex align-items-center justify-content-between mb-2 overflow-hidden">
                                <div>
                                    <p class="fs-12 fw-normal mb-1 text-truncate">Total Leaves</p>
                                    <h4><asp:Label ID="Label1" runat="server" Text="0"></asp:Label></h4>
                                </div>
                                <div class="leave-report-icon">
                                    <a href="#"><span class="p-2 border border-primary bg-transparent-primary rounded-circle d-flex align-items-center justify-content-center"><i class="ti ti-calendar-x text-primary"></i></span></a>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>

                <!-- Approved Leaves -->
                <div class="col-lg-6 col-md-6 d-flex">
                    <div class="card flex-fill">
                        <div class="card-body">
                            <div class="d-flex align-items-center justify-content-between mb-2 overflow-hidden">
                                <div>
                                    <p class="fs-12 fw-normal mb-1 text-truncate">Approved Leaves</p>
                                    <h4><asp:Label ID="Label2" runat="server" Text="0"></asp:Label></h4>
                                </div>
                                <div class="leave-report-icon">
                                    <a href="#"><span class="p-2 border border-success bg-transparent-success rounded-circle d-flex align-items-center justify-content-center"><i class="ti ti-calendar-x text-success"></i></span></a>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>

                <!-- Pending Requests -->
                <div class="col-lg-6 col-md-6 d-flex">
                    <div class="card flex-fill">
                        <div class="card-body">
                            <div class="d-flex align-items-center justify-content-between mb-2 overflow-hidden">
                                <div>
                                    <p class="fs-12 fw-normal mb-1 text-truncate">Pending Requests</p>
                                    <h4><asp:Label ID="Label3" runat="server" Text="0"></asp:Label></h4>
                                </div>
                                <div class="leave-report-icon">
                                    <a href="#"><span class="p-2 border border-skyblue bg-transparent-skyblue rounded-circle d-flex align-items-center justify-content-center"><i class="ti ti-calendar-x text-skyblue"></i></span></a>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>

                <!-- Rejected Leaves -->
                <div class="col-lg-6 col-md-6 d-flex">
                    <div class="card flex-fill">
                        <div class="card-body">
                            <div class="d-flex align-items-center justify-content-between mb-2 overflow-hidden">
                                <div>
                                    <p class="fs-12 fw-normal mb-1 text-truncate">Rejected Leaves</p>
                                    <h4><asp:Label ID="Label4" runat="server" Text="0"></asp:Label></h4>
                                </div>
                                <div class="leave-report-icon">
                                    <a href="#"><span class="p-2 border border-danger bg-transparent-danger rounded-circle d-flex align-items-center justify-content-center"><i class="ti ti-calendar-x text-danger"></i></span></a>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>

        <!-- Chart -->
        <div class="col-xl-6 d-flex">
            <div class="card flex-fill">
                <div class="card-header border-0 pb-0">
                    <div class="d-flex flex-wrap justify-content-between align-items-center row-gap-2">
                        <div class="d-flex align-items-center ">
                            <span class="me-2"><i class="ti ti-chart-bar text-danger"></i></span>
                            <h5>Leaves</h5>
                        </div>
                    </div>
                </div>
                <div class="card-body py-0">
                    <div>
                        <canvas id="leaveChart" width="400" height="300"></canvas>
                    </div>
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
                    <asp:DropDownList ID="DropDownList3" runat="server" CssClass="form-control" AutoPostBack="true" OnSelectedIndexChanged="DropDownList3_SelectedIndexChanged">
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
                    <asp:DropDownList ID="DropDownList1" runat="server" CssClass="form-control" AutoPostBack="true" OnSelectedIndexChanged="DropDownList1_SelectedIndexChanged">
                        <asp:ListItem Text="--Select Status--" Value=""></asp:ListItem>
                        <asp:ListItem Text="Pending" Value="Pending"></asp:ListItem>
                        <asp:ListItem Text="Approved" Value="Approved"></asp:ListItem>
                        <asp:ListItem Text="Rejected" Value="Rejected"></asp:ListItem>
                    </asp:DropDownList>
                </div>

                <!-- Sort -->
                <div class="col-md-4">
                    <label>Sort By:</label>
                    <asp:DropDownList ID="DropDownList2" runat="server" CssClass="form-control" AutoPostBack="true" OnSelectedIndexChanged="DropDownList2_SelectedIndexChanged">
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
        <div class="custom-datatable-filter table-responsive">
            <asp:GridView ID="GridView1" runat="server" AutoGenerateColumns="false" CssClass="table table-bordered" HeaderStyle-CssClass="thead-light" GridLines="None">
                <Columns>
                    <asp:BoundField DataField="ID" HeaderText="ID" />
                    <asp:TemplateField HeaderText="UserName">
                        <ItemTemplate>
                            <strong><%# Eval("UserName") %></strong>
                        </ItemTemplate>
                    </asp:TemplateField>
                    <asp:BoundField DataField="LeaveType" HeaderText="Leave Type" />
                    <asp:BoundField DataField="StartDate" HeaderText="Start Date" DataFormatString="{0:yyyy-MM-dd}" />
                    <asp:BoundField DataField="EndDate" HeaderText="End Date" DataFormatString="{0:yyyy-MM-dd}" />
                    <asp:BoundField DataField="Days" HeaderText="Days" />
                    <asp:BoundField DataField="Reason" HeaderText="Reason" />
                    <asp:BoundField DataField="ApprovedBy" HeaderText="Approved By" />
                    <asp:TemplateField HeaderText="Status">
                        <ItemTemplate>
                            <span class='badge <%# Eval("Status").ToString() == "Approved" ? "bg-success" : Eval("Status").ToString() == "Rejected" ? "bg-danger" : "bg-warning text-dark" %>'>
                                <%# Eval("Status") %>
                            </span>
                        </ItemTemplate>
                    </asp:TemplateField>
                    <asp:TemplateField HeaderText="Status History">
                        <ItemTemplate>
                            <span style="white-space:pre-line;"><%# Eval("StatusHistory") %></span>
                        </ItemTemplate>
                    </asp:TemplateField>
                </Columns>
            </asp:GridView>
        </div>
    </div>

</div>

<script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
<script>
    document.addEventListener('DOMContentLoaded', function () {
        const ctx = document.getElementById('leaveChart').getContext('2d');
        new Chart(ctx, {
            type: 'doughnut',
            data: {
                labels: ['Approved', 'Rejected', 'Pending'],
                datasets: [{
                    data: [2, 7, 1],
                    backgroundColor: ['#28a745', '#dc3545', '#ffc107']
                }]
            },
            options: { responsive: true, maintainAspectRatio: false }
        });
    });
</script>
</asp:Content>
