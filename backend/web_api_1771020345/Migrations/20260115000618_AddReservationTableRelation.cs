using System;
using Microsoft.EntityFrameworkCore.Migrations;

#nullable disable

namespace web_api_1771020345.Migrations
{
    /// <inheritdoc />
    public partial class AddReservationTableRelation : Migration
    {
        /// <inheritdoc />
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.AlterColumn<string>(
                name: "TableNumber",
                table: "Reservations",
                type: "nvarchar(450)",
                nullable: true,
                oldClrType: typeof(string),
                oldType: "nvarchar(max)",
                oldNullable: true);

            migrationBuilder.AlterColumn<DateTime>(
                name: "CreatedAt",
                table: "Reservations",
                type: "datetime2",
                nullable: false,
                defaultValueSql: "GETUTCDATE()",
                oldClrType: typeof(DateTime),
                oldType: "datetime2");

            migrationBuilder.AddUniqueConstraint(
                name: "AK_Tables_TableNumber",
                table: "Tables",
                column: "TableNumber");

            migrationBuilder.CreateIndex(
                name: "IX_Reservations_TableNumber",
                table: "Reservations",
                column: "TableNumber");

            migrationBuilder.AddForeignKey(
                name: "FK_Reservations_Tables_TableNumber",
                table: "Reservations",
                column: "TableNumber",
                principalTable: "Tables",
                principalColumn: "TableNumber",
                onDelete: ReferentialAction.Restrict);
        }

        /// <inheritdoc />
        protected override void Down(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropForeignKey(
                name: "FK_Reservations_Tables_TableNumber",
                table: "Reservations");

            migrationBuilder.DropUniqueConstraint(
                name: "AK_Tables_TableNumber",
                table: "Tables");

            migrationBuilder.DropIndex(
                name: "IX_Reservations_TableNumber",
                table: "Reservations");

            migrationBuilder.AlterColumn<string>(
                name: "TableNumber",
                table: "Reservations",
                type: "nvarchar(max)",
                nullable: true,
                oldClrType: typeof(string),
                oldType: "nvarchar(450)",
                oldNullable: true);

            migrationBuilder.AlterColumn<DateTime>(
                name: "CreatedAt",
                table: "Reservations",
                type: "datetime2",
                nullable: false,
                oldClrType: typeof(DateTime),
                oldType: "datetime2",
                oldDefaultValueSql: "GETUTCDATE()");
        }
    }
}
