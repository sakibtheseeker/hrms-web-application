console.log("role.js loaded");

let roleTable = null;

$(document).ready(function () {
    fetchRoles();
});

/* ================= FETCH ROLES ================= */
function fetchRoles() {

    $.ajax({
        type: "POST",
        url: "AddRole.aspx/GetRoles",
        contentType: "application/json; charset=utf-8",
        dataType: "json",
        success: function (res) {

            let data = res.d;
            let rows = "";

            $.each(data, function (i, item) {
                rows += `
                <tr>
                    <td>${item.RoleId}</td>
                    <td>${item.RoleName}</td>
                    <td>
                        <span class="badge toggle-status cursor-pointer
                            ${item.Status === "Active" ? "bg-success" : "bg-danger"}"
                            data-id="${item.RoleId}" style="pointer-events:auto">
                            ${item.Status}
                        </span>
                    </td>
                    <td>${item.CreatedBy ?? ""}</td>
                    <td>${item.ModifiedBy ?? ""}</td>
                    <td>
                        <a href="#" class="edit-btn" data-id="${item.RoleId}">
                            <i class="ti ti-edit"></i>
                        </a>
                        <a href="#" class="delete-btn" data-id="${item.RoleId}">
                            <i class="ti ti-trash"></i>
                        </a>
                    </td>
                </tr>`;
            });

            $("#roleTable tbody").html(rows);

            if (!$.fn.DataTable.isDataTable("#roleTable")) {
                roleTable = $("#roleTable").DataTable();
            }

            attachEventHandlers();
        },
        error: function () {
            alert("Failed to load roles");
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
        fetchRoleDetails($(this).data("id"));
    });

    $(document).on("click", ".delete-btn", function (e) {
        e.preventDefault();
        e.stopPropagation();
        if (confirm("Make role inactive?")) {
            toggleRoleStatus($(this).data("id"));
        }
    });

    $(document).on("click", ".toggle-status", function (e) {
        e.preventDefault();
        e.stopPropagation();
        if (confirm("Change role status?")) {
            toggleRoleStatus($(this).data("id"));
        }
    });
}

/* ================= TOGGLE STATUS ================= */
function toggleRoleStatus(id) {

    $.ajax({
        type: "POST",
        url: "AddRole.aspx/ToggleRoleStatus",
        data: JSON.stringify({ roleId: id }),
        contentType: "application/json; charset=utf-8",
        success: function () {
            fetchRoles();
        },
        error: function () {
            alert("Failed to change role status");
        }
    });
}

/* ================= EDIT ================= */
function fetchRoleDetails(id) {

    $.ajax({
        type: "POST",
        url: "AddRole.aspx/GetRoleById",
        data: JSON.stringify({ roleId: id }),
        contentType: "application/json; charset=utf-8",
        dataType: "json",
        success: function (res) {

            let r = res.d;

            $("#editRoleId").val(r.RoleId);
            $("#editRoleName").val(r.RoleName);
            $("#editStatus").val(r.Status);

            let modal = bootstrap.Modal.getOrCreateInstance(
                document.getElementById("editModal")
            );
            modal.show();
        }
    });
}
