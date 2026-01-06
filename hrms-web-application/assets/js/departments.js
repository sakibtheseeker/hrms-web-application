console.log("departments.js loaded");

let deptTable = null;

$(document).ready(function () {
    fetchDept();
});

/* ================= STATUS FILTER ================= */
$("#sts").on("change", function () {
    if (!deptTable) return; var value = $(this).val(); if (value === "select") { deptTable.column(3).search("").draw(); return; }
    $.fn.dataTable.ext.search.push(function (settings, data) { var statusText = $("<div>").html(data[3]).text().trim(); return statusText === value; }); deptTable.draw();
    $.fn.dataTable.ext.search.pop();
});



/* ================= SORT ================= */
$("#opt").on("change", function () {

    if (!deptTable) return;

    var sortVal = $(this).val();
    var statusVal = $("#sts").val();

    // preserve status filter
    if (statusVal !== "select") {
        deptTable.column(3).search(statusVal);
    } else {
        deptTable.column(3).search("");
    }

    if (sortVal === "asc") {
        deptTable.order([1, "asc"]).draw();
    }
    else if (sortVal === "desc") {
        deptTable.order([1, "desc"]).draw();
    }
});



/* ================= ADD DEPARTMENT ================= */
$("#savebtn").click(function () {

    if (!$("#Name").val() || !$("#Status").val()) {
        alert("Please fill all fields");
        return;
    }

    $.ajax({
        type: "POST",
        url: "AddDepartment.aspx/AddNewDepartment",
        data: JSON.stringify({
            name: $("#Name").val(),
            status: $("#Status").val()
        }),
        contentType: "application/json; charset=utf-8",
        success: function () {

            let modal = bootstrap.Modal.getOrCreateInstance(
                document.getElementById("exampleModal")
            );
            modal.hide();

            $("#Name").val("");
            $("#Status").val("");

            fetchDept();
        },
        error: function () {
            alert("Error adding department");
        }
    });
});

/* ================= FETCH DEPARTMENTS ================= */
function fetchDept() {
    $.ajax({
        type: "POST",
        url: "AddDepartment.aspx/GetDepartments",
        contentType: "application/json; charset=utf-8",
        dataType: "json",
        success: function (response) {

            let data = response.d;
            let rows = "";

            $.each(data, function (i, item) {
                rows += `
                <tr>
                    <td>${item.DepartmentId}</td>
                    <td>${item.Name}</td>
                    <td>${item.NoOfEmployee}</td>
                    <td>
                        <span class="badge toggle-status cursor-pointer
                            ${item.Status === "Active" ? "bg-success" : "bg-danger"}"
                            data-id="${item.DepartmentId}" style="pointer-events:auto">
                            ${item.Status}
                        </span>
                    </td>
                    <td>${item.CreatedBy ?? ""}</td>
                    <td>${item.ModifiedBy ?? ""}</td>
                    <td>
                        <a href="#" class="edit-btn" data-id="${item.DepartmentId}">
                            <i class="ti ti-edit"></i>
                        </a>
                        <a href="#" class="delete-btn" data-id="${item.DepartmentId}">
                            <i class="ti ti-trash"></i>
                        </a>
                    </td>
                </tr>`;
            });

            $("#departmentTable tbody").html(rows);

            if (!$.fn.DataTable.isDataTable("#departmentTable")) {
                deptTable = $("#departmentTable").DataTable();
            }

            attachEventHandlers();
        },
        error: function () {
            alert("Failed to load departments");
        }
    });
}

/* ================= EVENTS ================= */
function attachEventHandlers() {

    $(document).off("click", ".edit-btn");
    $(document).off("click", ".delete-btn");
    $(document).off("click", ".toggle-status");

    $(document).on("click", ".edit-btn", function (e) {
        e.preventDefault();
        e.stopPropagation();
        fetchDeptDetails($(this).data("id"));
    });

    $(document).on("click", ".delete-btn", function (e) {
        e.preventDefault();
        e.stopPropagation();
        if (confirm("Change department status?")) {
            toggleDepartmentStatus($(this).data("id"));
        }
    });

    $(document).on("click", ".toggle-status", function (e) {
        e.preventDefault();
        e.stopPropagation();
        if (confirm("Change department status?")) {
            toggleDepartmentStatus($(this).data("id"));
        }
    });
}




/* ================= EDIT ================= */
function fetchDeptDetails(id) {
    $.ajax({
        type: "POST",
        url: "AddDepartment.aspx/GetDepartmentById",
        data: JSON.stringify({ departmentId: id }),
        contentType: "application/json; charset=utf-8",
        dataType: "json",
        success: function (res) {

            let d = res.d;
            $("#DepartmentId").val(d.DepartmentId);
            $("#editName").val(d.Name);
            $("#editStatus").val(d.Status);

            let modalEl = document.getElementById("editModal");
            let modal = bootstrap.Modal.getOrCreateInstance(modalEl);
            modal.show();

            // ✅ HARD CLEANUP (REQUIRED WITH DATATABLE)
            document.body.classList.remove("modal-open");
            document.querySelectorAll(".modal-backdrop").forEach(b => b.remove());

        },
        error: function () {
            alert("Failed to fetch department");
        }
    });
}

/* ================= SAVE EDIT ================= */
$("#saveEdit").click(function () {

    $.ajax({
        type: "POST",
        url: "AddDepartment.aspx/UpdateDepartment",
        data: JSON.stringify({
            departmentId: $("#DepartmentId").val(),
            name: $("#editName").val(),
            status: $("#editStatus").val()
        }),
        contentType: "application/json; charset=utf-8",
        success: function () {

            let modal = bootstrap.Modal.getOrCreateInstance(
                document.getElementById("editModal")
            );
            modal.hide();

            fetchDept();
        },
        error: function () {
            alert("Failed to update department");
        }
    });
});

/* ================= TOGGLE STATUS ================= */
function toggleDepartmentStatus(id) {
    $.ajax({
        type: "POST",
        url: "AddDepartment.aspx/ToggleDepartmentStatus",
        data: JSON.stringify({ departmentId: id }),
        contentType: "application/json; charset=utf-8",
        success: function () {
            fetchDept();
        },
        error: function () {
            alert("Failed to change status");
        }
    });
}
