<%@ Page Title="" Language="C#" MasterPageFile="~/EmployeeMaster.Master" AutoEventWireup="true" CodeBehind="EmployeeAttendance.aspx.cs" Inherits="hrms_web_application.EmployeeAttendance" %>
<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">

    <script src="https://cdnjs.cloudflare.com/ajax/libs/jspdf/2.5.1/jspdf.umd.min.js"></script>
    <asp:HiddenField ID="hfChartLabels" runat="server" />
<asp:HiddenField ID="hfChartValues" runat="server" />


    <div class="card mt-3">
    <div class="card-body">
        <h5>Timeline Graph (Minutes)</h5>

        <canvas id="timeChart" height="30"></canvas>

            <button class="btn btn-success" onclick="downloadPNG()">Download PNG</button>
            <button class="btn btn-danger" onclick="downloadPDF()">Download PDF</button>
     
    </div>
        </div>


<div class="card p-3 mb-3">


        <div class="d-flex justify-content-between align-items-center">
            <div>
                <h4>Welcome, <asp:Label ID="lblUserName" runat="server" /></h4>
                <p>Email: <asp:Label ID="lblEmail" runat="server" /></p>
                <p>Today: <%= DateTime.Now.ToString("dd MMM yyyy hh:mm tt") %></p>
                <p>Punched In: <asp:Label ID="lblPunchIn" runat="server" /></p>
                <p>Production Time: <asp:Label ID="lblProductionTime" runat="server" /></p>
            </div>
            <div>
                <asp:Image ID="imgProfile" runat="server" Width="100" Height="100" CssClass="rounded-circle" />
            </div>
        </div>

        <asp:Button ID="btnAttendance" runat="server" CssClass="btn btn-success mt-3"
            OnClick="btnAttendance_Click" />
    </div>
    <div>               <asp:Button
    ID="timesheetBtn"
    runat="server"
    CssClass="btn btn-success mt-3"
    Text="Add Details In timesheet"
    Enabled="false"
    OnClick="Timesheet_Click" />
</div>

    <div class="row text-center mb-4 card row-cols-5">
        <div class="col"><strong>Total Hours Today:</strong> <asp:Label ID="lblTodayHours" runat="server" /></div>
        <div class="col"><strong>Total Hours Week:</strong> <asp:Label ID="lblWeekHours" runat="server" /></div>
        <div class="col"><strong>Total Hours Month:</strong> <asp:Label ID="lblMonthHours" runat="server" /></div>
        <div class="col"><strong>Overtime this Month:</strong> <asp:Label ID="lblOvertime" runat="server" /></div>
    </div>

    <div class="card p-3 mb-3">
    <h5>Timeline Graph (Daily Production Minutes)</h5>
    <canvas id="attendanceChart" height="100"></canvas>
</div>


    <asp:GridView ID="gvAttendance" runat="server" CssClass="table table-bordered" AutoGenerateColumns="false">
        <Columns>
            <asp:BoundField DataField="Date" HeaderText="Date" DataFormatString="{0:yyyy-MM-dd}" />
            <asp:BoundField DataField="CheckIn" HeaderText="Check In" DataFormatString="{0:hh:mm tt}" />
            <asp:BoundField DataField="Status" HeaderText="Status" />
            <asp:BoundField DataField="CheckOut" HeaderText="Check Out" DataFormatString="{0:hh:mm tt}" />
            <asp:BoundField DataField="BreakHours" HeaderText="Break (hrs)" />
            <asp:BoundField DataField="Late" HeaderText="Late (min)" />
            <asp:BoundField DataField="OvertimeHours" HeaderText="Overtime (hrs)" />
            <asp:BoundField DataField="ProductionHours" HeaderText="Production (hrs)" />
        </Columns>
    </asp:GridView>
        <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
<script src="https://cdn.jsdelivr.net/npm/chart.js"></script>

<script>
    const labels = JSON.parse(
        document.getElementById('<%= hfChartLabels.ClientID %>').value || "[]"
    );

    const values = JSON.parse(
        document.getElementById('<%= hfChartValues.ClientID %>').value || "[]"
    );

    const ctx = document.getElementById('attendanceChart').getContext('2d');

    new Chart(ctx, {
        type: 'line',
        data: {
            labels: labels,
            datasets: [{
                label: 'Production Minutes',
                data: values,
                borderColor: '#0d6efd',
                backgroundColor: 'rgba(13,110,253,0.2)',
                tension: 0.3,
                fill: true
            }]
        },
        options: {
            responsive: true,
            scales: {
                y: { beginAtZero: true }
            }
        }
    });
</script>


   <script>
       function downloadPNG() {
           const canvas = document.getElementById('attendanceChart');
           const link = document.createElement('a');
           link.href = canvas.toDataURL('image/png');
           link.download = 'Attendance_Graph.png';
           link.click();
       }
   </script>


<script>
    function downloadPDF() {
        const { jsPDF } = window.jspdf;
        const pdf = new jsPDF();

        const canvas = document.getElementById('attendanceChart');
        const imgData = canvas.toDataURL('image/png');

        pdf.text("Attendance Production Minutes", 10, 10);
        pdf.addImage(imgData, 'PNG', 10, 20, 180, 90);
        pdf.save("Attendance_Graph.pdf");
    }
</script>



</asp:Content>

