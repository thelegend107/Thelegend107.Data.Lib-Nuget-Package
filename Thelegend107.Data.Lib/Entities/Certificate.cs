﻿using System.ComponentModel.DataAnnotations.Schema;

namespace Thelegend107.Data.Lib.Entities
{
    [Table("Certificate")]
    public partial record Certificate
    {
        public int Id { get; set; }
        public int UserId { get; set; }
        public string Name { get; set; } = null!;
        public string? CertificateId { get; set; }
        public string? URL { get; set; }
        public string? IssuedBy { get; set; }
        public DateTime? IssueDate { get; set; }
    }
}