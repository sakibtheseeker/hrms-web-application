console.log("designation.js loaded");

let desiTable = null;

$(document).ready(function () {
    fetchDesignation();
});

/* ================= STATUS FILTER ================= */
$("#sts").on("change", function () {

    if (!desiTable) return;

    var value = $(this).val();

    if (value === "0") {
        desiTable.column(4).search("").draw();
        return;
    }


    $.fn.dataTable.ext.search.push(function (settings, data) {
        let statusText = $("<div>").html(data[4]).text().trim();
        return statusText === value;
    });

    desiTable.draw();
    $.fn.dataTable.ext.search.pop();
});

/* ================= SORT ================= */
$("#opt").on("change", function () {

    if (!desiTable) return;

    let val = $(this).val();

    if (val === "asc") {
        desiTable.order([1, "asc"]).draw();
    } else if (val === "desc") {
        desiTable.order([1, "desc"]).draw();
    }
});

/* ================= FETCH DESIGNATIONS ================= */

function fetchDesignation() {

    $.ajax({
        type: "POST",
        url: "AddDesignation.aspx/GetDesignations",
        contentType: "application/json; charset=utf-8",
        dataType: "json",
        success: function (res) {

            let data = res.d;

            // 🔥 FIRST TIME INIT
            if (!desiTable) {

                desiTable = $("#designationTable").DataTable({
                    data: data,
                    pageLength: 5,
                    lengthMenu: [5, 10, 25, 50],
                    ordering: true,
                    searching: true,
                    responsive: true,
                    autoWidth: false,
                    columns: [
                        { data: "DesignationId" },
                        { data: "Name" },
                        { data: "DepartmentName" },
                        { data: "NoOfEmployee" },
                        {
                            data: "Status",
                            render: function (data, type, row) {
                                return `
                                <span class="badge toggle-status cursor-pointer
                                    ${data === "Active" ? "bg-success" : "bg-danger"}"
                                    data-id="${row.DesignationId}">
                                    ${data}
                                </span>`;
                            }
                        },
                        { data: "CreatedBy", defaultContent: "" },
                        { data: "ModifiedBy", defaultContent: "" },
                        {
                            data: null,
                            orderable: false,
                            render: function (data, type, row) {
                                return `
                                    <a href="#" class="edit-btn" data-id="${row.DesignationId}">
                                        <i class="ti ti-edit"></i>
                                    </a>
                                    <a href="#" class="delete-btn" data-id="${row.DesignationId}">
                                        <i class="ti ti-trash"></i>
                                    </a>`;
                            }
                        }
                    ]
                });

                attachEventHandlers();
            }
            // 🔁 RELOAD DATA (THIS WAS MISSING)
            else {
                desiTable.clear();
                desiTable.rows.add(data);
                desiTable.draw(false);
            }
        },
        error: function () {
            alert("Failed to load designations");
        }
    });
}


/* ================= EVENTS ================= */


/* ================= EDIT ================= */

function fetchDesignationDetails(id) {
    $.ajax({
        type: "POST",
        url: "AddDesignation.aspx/GetDesignationById",
        data: JSON.stringify({ designationId: id }),
        contentType: "application/json; charset=utf-8",
        dataType: "json",
        success: function (res) {
            let d = res.d;

            $("#DesignationId").val(d.DesignationId);
            $("#editDesignationname").val(d.Name);
            $("#ddlDepartmentEdit").val(d.DepartmentId);
            $("#status").val(d.Status);

            bootstrap.Modal.getOrCreateInstance(
                document.getElementById("editModal")
            ).show();
        }
    });
}





/* ================= SAVE EDIT ================= */
$("#saveEdit").off("click").on("click", function () {

    const designationId = parseInt($("#DesignationId").val());
    const departmentId = parseInt($("#ddlDepartmentEdit").val());
    const name = $("#editDesignationname").val().trim();
    const status = $("#status").val();

    console.log("SAVE DEBUG →", { designationId, departmentId, name, status });

    if (!designationId || !departmentId || !name || !status) {
        alert("Invalid data. Please fill all fields.");
        return;
    }

    $.ajax({
        type: "POST",
        url: "AddDesignation.aspx/UpdateDesignation",
        contentType: "application/json; charset=utf-8",
        data: JSON.stringify({
            designationId,
            departmentId,
            name,
            status
        }),
        success: function () {
            bootstrap.Modal.getInstance(
                document.getElementById("editModal")
            ).hide();

            fetchDesignation();
        },
        error: function (xhr) {
            console.error(xhr.responseText);
            alert("Failed to update designation");
        }
    });
});







/* ================= TOGGLE STATUS ================= */
function toggleDesignationStatus(id) {

    $.ajax({
        type: "POST",
        url: "AddDesignation.aspx/ToggleDesignationStatus",
        data: JSON.stringify({ designationId: id }),
        contentType: "application/json; charset=utf-8",
        success: function () {
            fetchDesignation();
        }
    });
}

/* ================= SOFT DELETE (MAKE INACTIVE) ================= */
function softDeleteDesignation(id) {

    $.ajax({
        type: "POST",
        url: "AddDesignation.aspx/SoftDeleteDesignation",
        data: JSON.stringify({ designationId: id }),
        contentType: "application/json; charset=utf-8",
        success: function () {
            fetchDesignation();   // 🔄 reload table
        },
        error: function (err) {
            console.error(err);
            alert("Failed to change designation status");
        }
    });
}

// ================= DATATABLE EVENTS =================

// EDIT
$("#designationTable tbody").on("click", ".edit-btn", function (e) {
    e.preventDefault();
    let data = desiTable.row($(this).closest("tr")).data();
    fetchDesignationDetails(data.DesignationId);
});

// SOFT DELETE (TRASH)
$("#designationTable tbody").on("click", ".delete-btn", function (e) {
    e.preventDefault();
    let data = desiTable.row($(this).closest("tr")).data();

    if (confirm("Make this designation inactive?")) {
        softDeleteDesignation(data.DesignationId);
    }
});

// TOGGLE STATUS (BADGE)
$("#designationTable tbody").on("click", ".toggle-status", function () {
    let data = desiTable.row($(this).closest("tr")).data();

    if (confirm("Change designation status?")) {
        toggleDesignationStatus(data.DesignationId);
    }
});
