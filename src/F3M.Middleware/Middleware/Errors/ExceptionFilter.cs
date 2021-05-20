using F3M.Core.Components.WebApi.Extensions;
using F3M.Core.Domain.Validators;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.Mvc.Filters;
using Microsoft.Data.SqlClient;
using Microsoft.EntityFrameworkCore;
using System;
using System.Collections.Generic;
using System.Net;
using System.Text.RegularExpressions;

namespace F3M.Middleware.Middleware.Errors
{
    public class ExceptionFilter : IExceptionFilter
    {
        public const int SqlServerViolationOfUniqueIndex = 2601;
        public const int SqlServerViolationOfUniqueConstraint = 2627;
        public const int SqlServerViolationOfDeleteForeignKeyConstraint = 547;
        private static readonly Regex UniqueConstraintRegex = new Regex("IX_([a-zA-Z0-9_]*)", RegexOptions.Compiled);
        private static readonly Regex DeleteForeignKeyConstraintRegex = new Regex("FK_([a-zA-Z0-9_]*)", RegexOptions.Compiled);

        ///<Summary>
        /// Gets the answer
        ///</Summary>
        public void OnException(ExceptionContext context)
        {
            var contextException = context.Exception;
            var status = HttpStatusCode.InternalServerError;
            IActionResult result = null;
            var innerException = context.Exception;

            var dbUpdateEx = innerException as DbUpdateException;
            SqlException sqlEx = (SqlException)dbUpdateEx?.InnerException;
            if (sqlEx != null)
            {
                if (sqlEx.Number == SqlServerViolationOfUniqueIndex || sqlEx.Number == SqlServerViolationOfUniqueConstraint)
                {
                    var matches = UniqueConstraintRegex.Matches(sqlEx.Errors[0].Message);
                    result = DomainResult.Failure(matches[0].Value.ToString()).ToActionResult();
                    innerException = null;
                }

                if (sqlEx.Number == SqlServerViolationOfDeleteForeignKeyConstraint)
                {
                    var matches = DeleteForeignKeyConstraintRegex.Matches(sqlEx.Errors[0].Message);
                    result = DomainResult.Failure(matches[0].Value.ToString()).ToActionResult();
                    innerException = null;
                }
            }

            List<string> errorList = new List<string>();
            if (result == null)
            {
                while (innerException != null)
                {
                    errorList.Add(innerException.Message);
                    innerException = innerException.InnerException;
                }
                result = DomainResult.Failure(errorList).ToActionResult();
            }

            if (contextException.GetType() == typeof(UnauthorizedAccessException))
            {
                status = HttpStatusCode.Unauthorized;
                result = DomainResult.Failure(errorList, null, HttpStatusCode.Unauthorized).ToActionResult();
            }

            if (contextException.GetType() == typeof(NullReferenceException))
            {
                status = HttpStatusCode.NotFound;
                result = DomainResult.Failure(errorList, null, HttpStatusCode.NotFound).ToActionResult();
            }

            HttpResponse response = context.HttpContext.Response;
            response.StatusCode = (int)status;
            response.ContentType = "application/json";
            context.Result = result;
        }
    }
}