<%@ Page Title="" Language="C#" MasterPageFile="~/AdminMaster.Master" AutoEventWireup="true" CodeBehind="ProjectReports.aspx.cs" Inherits="$safeprojectname$.ProjectReports" %>
<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">
              		<div class="content">

			<!-- Breadcrumb -->
			<div class="d-md-flex d-block align-items-center justify-content-between page-breadcrumb mb-3">
				<div class="my-auto mb-2">
					<h2 class="mb-1">Project Report</h2>
					<nav>
						<ol class="breadcrumb mb-0">
							<li class="breadcrumb-item">
								<a href="index.html"><i class="ti ti-smart-home"></i></a>
							</li>
							<li class="breadcrumb-item">
								HR
							</li>
							<li class="breadcrumb-item active" aria-current="page">Project Report</li>
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
				<div class="col-lg-6 col-md-6 d-flex">
					<div class="row flex-fill">
						<div class="col-lg-6 col-md-6 d-flex">
							<div class="card flex-fill">
								<div class="card-body ">
									<div>
											<div class="mb-2">
												<span class="fs-14 fw-normal text-truncate mb-1">Total Projects</span>
												<h5>
                            <asp:Label ID="lblTotalProjects" runat="server" Text="0"></asp:Label>
                        </h5>
											</div>
											<div class="progress" role="progressbar" aria-label="Basic example" aria-valuenow="0" aria-valuemin="0" aria-valuemax="100" style="width: 100%;height: 5px;">
												<div class="progress-bar bg-pink" style="width: 70%"></div>
											</div>
									</div>
									<div class="d-flex mt-2">
										<p class="fs-12 fw-normal d-flex align-items-center text-truncate"><span class="text-success fs-12 d-flex align-items-center me-1"><i class="ti ti-arrow-wave-right-up me-1"></i>+10.54%</span>from last month</p>
									</div>
								</div>
							</div>
						</div>
						<div class="col-lg-6 col-md-6 d-flex">
							<div class="card flex-fill">
								<div class="card-body ">
									<div>
											<div class="mb-2">
												<span class="fs-14 fw-normal text-truncate mb-1">Completed Projects</span>
												<h5>
                            <asp:Label ID="lblCompletedProjects" runat="server" Text="0"></asp:Label>
                        </h5>
											</div>
											<div class="progress" role="progressbar" aria-label="Basic example" aria-valuenow="0" aria-valuemin="0" aria-valuemax="100" style="width: 100%;height: 5px;">
												<div class="progress-bar bg-success" style="width: 80%"></div>
											</div>
									</div>
									<div class="d-flex mt-2">
										<p class="fs-12 fw-normal d-flex align-items-center text-truncate"><span class="text-success fs-12 d-flex align-items-center me-1"><i class="ti ti-arrow-wave-right-up me-1"></i>+12.84%</span>from last month</p>
									</div>
								</div>
							</div>
						</div>
						<div class="col-lg-6 col-md-6 d-flex">
							<div class="card flex-fill">
								<div class="card-body ">
									<div>
											<div class="mb-2">
												<span class="fs-14 fw-normal text-truncate mb-1">Pending Projects</span>
												<h5>
                            <asp:Label ID="lblPendingProjects" runat="server" Text="0"></asp:Label>
                        </h5>
											</div>
											<div class="progress" role="progressbar" aria-label="Basic example" aria-valuenow="0" aria-valuemin="0" aria-valuemax="100" style="width: 100%;height: 5px;">
												<div class="progress-bar bg-danger" style="width: 20%"></div>
											</div>
									</div>
									<div class="d-flex mt-2">
										<p class="fs-12 fw-normal d-flex align-items-center text-truncate"><span class="text-danger fs-12 d-flex align-items-center me-1"><i class="ti ti-arrow-wave-right-up me-1"></i>-10.75%</span>from last month</p>
									</div>
								</div>
							</div>
						</div>
						<div class="col-lg-6 col-md-6 d-flex">
							<div class="card flex-fill">
								<div class="card-body ">
									<div>
											<div class="mb-2">
												<span class="fs-14 fw-normal text-truncate mb-1">New Projects</span>
												<h5>
                            <asp:Label ID="lblNewProjects" runat="server" Text="0"></asp:Label>
                        </h5>
											</div>
											<div class="progress" role="progressbar" aria-label="Basic example" aria-valuenow="0" aria-valuemin="0" aria-valuemax="100" style="width: 100%;height: 5px;">
												<div class="progress-bar bg-purple" style="width: 60%"></div>
											</div>
									</div>
									<div class="d-flex mt-2">
										<p class="fs-12 fw-normal d-flex align-items-center text-truncate"><span class="text-success fs-12 d-flex align-items-center me-1"><i class="ti ti-arrow-wave-right-up me-1"></i>+15.74%</span>from last month</p>
									</div>
								</div>
							</div>
						</div>
					</div>

				</div>
				<!-- /Total Exponses -->

				<!-- Total Exponses -->
				<div class="col-lg-6 col-md-6 d-flex">
					<div class="card flex-fill">
						<div class="card-header border-0">
							<div class="d-flex flex-wrap justify-content-between align-items-center">
								<div class="d-flex align-items-center ">
									<span class="me-2"><i class="ti ti-chart-pie text-danger"></i></span>
									<h5>Projects By Tasks</h5>
								</div>
								<div class="dropdown">
									<a href="javascript:void(0);"
										class="dropdown-toggle btn btn-sm fs-12 btn-white d-inline-flex align-items-center"
										data-bs-toggle="dropdown">
										Office Management App
									</a>
									<ul class="dropdown-menu  dropdown-menu-end p-2">
										<li>
											<a href="javascript:void(0);" class="dropdown-item rounded-1">PRO-001</a>
										</li>
										<li>
											<a href="javascript:void(0);" class="dropdown-item rounded-1">PRO-002</a>
										</li>
										<li>
											<a href="javascript:void(0);" class="dropdown-item rounded-1">PRO-004</a>
										</li>
									</ul>
								</div>
							</div>
						</div>
						<div class="card-body pt-0">
							<div class="row align-items-center">
								<div class="col-md-6 d-flex justify-content-center">
									<div id="project-report">
									</div>
								</div>
								<div class="col-md-6">
									<div class="row gy-4">
										<div class="col-md-6">
											<p class="fs-16 project-report-badge-blue fw-normal mb-0 text-gray-5">Pending </p>
											<p class="fs-20 fw-bold text-dark ">30%</p>
										</div>
										<div class="col-md-6">
											<p class="fs-16 project-report-badge-purple mb-0  fw-normal text-gray-5">On Hold</p>
											<p class="fs-20 fw-bold text-dark ">10%</p>
										</div>
										<div class="col-md-6">
											<p class="fs-16 project-report-badge-warning  mb-0 fw-normal text-gray-5">Inprogress </p>
											<p class="fs-20 fw-bold text-dark ">20%</p>
										</div>
										<div class="col-md-6">
											<p class="fs-16 project-report-badge-success  mb-0 fw-normal text-gray-5">Completed</p>
											<p class="fs-20 fw-bold text-dark ">40%</p>
										</div>
									</div>
								</div>
							</div>
							

						</div>
					</div>
				</div>
				<!-- /Total Exponses -->


			</div>

			<div class="card mt-4">

    <!-- CARD HEADER -->
    <div class="card-header">

        <!-- ROW 1 : TITLE + FILTERS -->
        <div class="row align-items-center">
            <div class="col-md-4">
					<h5>Project List</h5>
					            </div>

            <div class="col-md-8">
                <div class="d-flex justify-content-end gap-2 flex-wrap">
                   <asp:DropDownList
    ID="ddlPrioritySort"
    runat="server"
    CssClass="form-select w-auto"
    AutoPostBack="true"
    OnSelectedIndexChanged="ddlPrioritySort_SelectedIndexChanged">

    <asp:ListItem Value="">Priority</asp:ListItem>
    <asp:ListItem Value="Low">Low</asp:ListItem>
    <asp:ListItem Value="Medium">Medium</asp:ListItem>
    <asp:ListItem Value="High">High</asp:ListItem>

</asp:DropDownList>
						
                    <asp:DropDownList
    ID="ddlStatusFilter"
    runat="server"
    CssClass="form-select w-auto"
    AutoPostBack="true"
    OnSelectedIndexChanged="ddlStatusFilter_SelectedIndexChanged">

    <asp:ListItem Text="Status" Value="" />
    <asp:ListItem Text="Active" Value="Active" />
    <asp:ListItem Text="Inactive" Value="Inactive" />
    

</asp:DropDownList>
						                    <asp:DropDownList
    ID="ddlSortBy"
    runat="server"
    CssClass="form-select w-auto"
    AutoPostBack="true"
    OnSelectedIndexChanged="ddlSortBy_SelectedIndexChanged">

    <asp:ListItem Text="Sort By" Value="" />
    <asp:ListItem Text="Recently Added" Value="recent" />
    <asp:ListItem Text="Ascending" Value="asc" />
    <asp:ListItem Text="Descending" Value="desc" />

</asp:DropDownList>

                </div>
            </div>
        </div>

        <!-- ROW 2 : SEARCH -->
        <div class="row mt-3">
    <div class="col-md-4 ms-auto">
        <asp:TextBox
            ID="txtSearch"
            runat="server"
            CssClass="form-control"
            Placeholder="Search tasks..."
            AutoPostBack="true"
            OnTextChanged="txtSearch_TextChanged" />
    </div>
</div>

        </div>

    </div>
				<div class="card-body p-0">
        <div>
            <div class="custom-datatable-filter table-responsive">
               <asp:GridView ID="gvProjectReport" runat="server" AutoGenerateColumns="False" CssClass="table table-striped table-bordered"
    HeaderStyle-CssClass="thead-light" GridLines="None" Width="100%">
    
    <Columns>
    <asp:TemplateField>
        <HeaderTemplate>
            <asp:CheckBox ID="chkSelectAll" runat="server" />
        </HeaderTemplate>
        <ItemTemplate>
            <asp:CheckBox ID="chkSelect" runat="server" />
        </ItemTemplate>
    </asp:TemplateField>

    <asp:BoundField DataField="ProjectId" HeaderText="Project ID" />
    <asp:BoundField DataField="ProjectName" HeaderText="Project Name" />
    <asp:BoundField DataField="Leader" HeaderText="Leader" />
    <asp:BoundField DataField="Members" HeaderText="Members" />
    <asp:BoundField DataField="Deadline" HeaderText="Deadline" DataFormatString="{0:dd-MM-yyyy}" />
    <asp:BoundField DataField="Priority" HeaderText="Priority" />

    <asp:TemplateField HeaderText="Status">
        <ItemTemplate>
            <span class='<%# Eval("Status").ToString() == "Active" ? "badge badge-success d-inline-flex align-items-center badge-xs" : "badge badge-danger d-inline-flex align-items-center badge-xs" %>'>
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
</div>
		
</asp:Content>
