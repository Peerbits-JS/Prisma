using F3M.Oticas.Data.Context;
using F3M.Oticas.Domain.Entities;
using F3M.Oticas.Interfaces.Repository;
using Microsoft.EntityFrameworkCore;
using System;
using System.Collections.Generic;
using System.Threading.Tasks;

namespace F3M.Oticas.Data.Repository
{
    public class TaxAuthorityComunicationRepository : OticasBaseRepository<TaxAuthorityComunication>, ITaxAuthorityComunicationRepository
    {
        public TaxAuthorityComunicationRepository(OticasContext context)
            : base(context)
        {
        }

        public override async Task<TaxAuthorityComunication> CreateAsync(TaxAuthorityComunication entity)
        {
            try
            {
                await EntitySet.AddAsync(entity);
                return entity;
            }
            catch (Exception ex)
            {
                throw new Exception($"Erro ao criar {typeof(TaxAuthorityComunication).Name}", ex);
            }
        }

        public override async Task<TaxAuthorityComunication> FindAsync(long id) 
            => await EntitySet.Include(x => x.TaxAuthorityComunicationProducts).FirstAsync(x => x.Id == id);
    }
}