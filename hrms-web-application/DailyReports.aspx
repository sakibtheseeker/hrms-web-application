<%@ Page Title="" Language="C#" MasterPageFile="~/AdminMaster.Master" AutoEventWireup="true" CodeBehind="DailyReports.aspx.cs" Inherits="hrms_web_application.DailyReports" %>
<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">
        <div class="content">

	<!-- Breadcrumb -->
	<div class="d-md-flex d-block align-items-center justify-content-between page-breadcrumb mb-3">
		<div class="my-auto mb-2">
			<h2 class="mb-1">Daily Report</h2>
			<nav>
				<ol class="breadcrumb mb-0">
					<li class="breadcrumb-item">
						<a href="index.html"><i class="ti ti-smart-home"></i></a>
					</li>
					<li class="breadcrumb-item">
						HR
					</li>
					<li class="breadcrumb-item active" aria-current="page">Daily Report</li>
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
        <div class="col-xl-6 d-flex">
            <div class="row flex-fill">

                <!-- Total Present -->
                <div class="col-lg-6 col-md-6 d-flex">
                    <div class="card flex-fill">
                        <div class="card-body">
                            <div class="d-flex align-items-center justify-content-between">
                                <h4>
                                    <asp:Label ID="Label1" runat="server" Text="0"></asp:Label>
                                </h4>
								<div class="leave-report-icon">
									<a href="#"><span class="p-2 border border-primary bg-transparent-primary rounded-circle d-flex align-items-center justify-content-center"><i class="ti ti-user-check text-primary"></i></span></a>
								</div>
                            </div>
                        </div>
                    </div>
                </div>

                <!-- Completed Tasks -->
                 <div class="col-lg-6 col-md-6 d-flex">
                    <div class="card flex-fill">
                        <div class="card-body">
                            <div class="d-flex align-items-center justify-content-between">
                                <div>
                                    <p class="fs-12 fw-normal mb-1 text-truncate">Completed Tasks</p>
                                    <h4>
                                        <asp:Label ID="Label2" runat="server" Text="0"></asp:Label>
                                    </h4>
                                </div>
								<div class="leave-report-icon">
									<a href="#"><span class="p-2 border border-success bg-transparent-success rounded-circle d-flex align-items-center justify-content-center"><i class="ti ti-subtask text-success"></i></span></a>
								</div>
                            </div>
                        </div>
                    </div>
                </div>

                <!-- Total Absent -->
                 <div class="col-lg-6 col-md-6 d-flex">
                    <div class="card flex-fill">
                        <div class="card-body">
                            <div class="d-flex align-items-center justify-content-between">
                                <div>
                                    <p class="fs-12 fw-normal mb-1 text-truncate">Total Absent</p>
                                   <h4>
                                        <asp:Label ID="Label3" runat="server" Text="0"></asp:Label>
                                   </h4>
                                </div>
								<div class="leave-report-icon">
									<a href="#"><span class="p-2 border border-danger bg-transparent-danger rounded-circle d-flex align-items-center justify-content-center"><i class="ti ti-user-x text-danger"></i></span></a>
								</div>
                            </div>
                        </div>
                    </div>
                </div>

                <!-- Pending Tasks -->
                 <div class="col-lg-6 col-md-6 d-flex">
                    <div class="card flex-fill">
                        <div class="card-body">
                            <div class="d-flex align-items-center justify-content-between">
                                <div>
                                    <p class="fs-12 fw-normal mb-1 text-truncate">Pending Tasks</p>
                                    <h4>
                                        <asp:Label ID="Label4" runat="server" Text="0"></asp:Label>
                                    </h4>
                                </div>
								<div class="leave-report-icon">
									<a href="#"><span class="p-2 border border-skyblue bg-transparent-skyblue rounded-circle d-flex align-items-center justify-content-center"><i class="ti ti-user-x text-skyblue"></i></span></a>
								</div>
                            </div>
                        </div>
                    </div>
                </div>

            </div>
        </div>

		<!-- Daily Attendance Chart -->
		<div class="col-xl-6 d-flex">
            <div class="card flex-fill">
				<div class="card-header border-0 pb-0">
					<div class="d-flex flex-wrap justify-content-between align-items-center">
						<div class="d-flex align-items-center ">
							<span class="me-2"><i class="ti ti-chart-bar text-danger"></i></span>
							<h5>Daily Attendance</h5>
						</div>
						<div class="d-flex align-items-center">
							<p class="d-inline-flex align-items-center me-2 mb-0">
								<i class="ti ti-square-filled fs-12 text-success me-2"></i>
								Present
							</p>
							<p class="d-inline-flex align-items-center mb-0 me-2">
								<i class="ti ti-square-filled fs-12 text-danger me-2"></i>
								Absent
							</p>
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
					<div id="daily-report"> </div>
				</div>
            </div>
        </div>				
	</div>

    <!-- Attendance List -->
    <div class="card">

     <div class="card-header">
         <div class="d-flex justify-content-between align-items-center mb-2 flex-wrap">

             <!-- Title Left -->
             <h5 class="mb-0">Daily Attendance List</h5>

             <!-- Filters Right -->
             <div class="d-flex flex-wrap align-items-center">
                 <!-- Status Dropdown -->
                 <div class="me-2 mb-2">
                     <asp:DropDownList ID="DropDownList1" runat="server" CssClass="form-select"
                         AutoPostBack="true" OnSelectedIndexChanged="DropDownList1_SelectedIndexChanged">
                         <asp:ListItem Text="All" Value=""></asp:ListItem>
                         <asp:ListItem Text="Active" Value="Active"></asp:ListItem>
                         <asp:ListItem Text="Inactive" Value="Inactive"></asp:ListItem>
                     </asp:DropDownList>
                 </div>

                 <!-- Sort Dropdown -->
                 <div class="dropdown me-2 mb-2">
                     <a href="javascript:void(0);" class="dropdown-toggle btn btn-white d-inline-flex align-items-center"
                        data-bs-toggle="dropdown">
                         Sort By
                     </a>
                     <ul class="dropdown-menu dropdown-menu-end p-3">
                         <li><a href="javascript:void(0);" class="dropdown-item rounded-1">Recently Added</a></li>
                         <li>
                             <asp:LinkButton ID="LinkButton1" runat="server" CssClass="dropdown-item rounded-1"
                                             OnClick="LinkButton1_Click">Ascending</asp:LinkButton>
                         </li>
                         <li>
                             <asp:LinkButton ID="LinkButton2" runat="server" CssClass="dropdown-item rounded-1"
                                             OnClick="LinkButton2_Click">Descending</asp:LinkButton>
                         </li>
                     </ul>
                 </div>
             </div>

         </div>

         <!-- Row 2: Search box right -->
         <div class="d-flex justify-content-end mb-0">
             <div style="width: 250px;">
                 <asp:TextBox ID="TextBox1" runat="server" CssClass="form-control"
                              Placeholder="Search employees..." AutoPostBack="true"
                              OnTextChanged="TextBox1_TextChanged" />
             </div>
         </div>
     </div>

	<div class="card-body p-0">
        <div class="custom-datatable-filter table-responsive">

            <asp:GridView ID="gvDailyReport"
                runat="server"
                CssClass="table datatable"
                AutoGenerateColumns="False"
                GridLines="None">

                <Columns>

                    <asp:TemplateField HeaderText="Name">
                        <ItemTemplate>
                            <div class="d-flex align-items-center">
                                <div>
                                    <p class="text-dark mb-0">
                                        <strong><%# Eval("Name") %></strong>
                                    </p>
                                    <span class="fs-12"><%# Eval("Department") %></span>
                                </div>
                            </div>
                        </ItemTemplate>
                    </asp:TemplateField>

                    <asp:BoundField
                        DataField="Date"
                        HeaderText="Date"
                        DataFormatString="{0:dd MMM yyyy}" />

                    <asp:BoundField
                        DataField="Department"
                        HeaderText="Department" />

                    <asp:TemplateField HeaderText="Status">
                        <ItemTemplate>
                            <span class='<%# Eval("Status").ToString() == "Present"
                                ? "badge badge-soft-success d-inline-flex align-items-center badge-xs"
                                : Eval("Status").ToString() == "Absent"
                                    ? "badge badge-soft-danger d-inline-flex align-items-center badge-xs"
                                    : "badge badge-soft-warning d-inline-flex align-items-center badge-xs" %>'>
                                <i class="ti ti-point-filled me-1"></i>
                                <%# Eval("Status") %>
                            </span>
                        </ItemTemplate>
                    </asp:TemplateField>

                </Columns>

            </asp:GridView>

        </div>
    </div>

</div>
</asp:Content>
