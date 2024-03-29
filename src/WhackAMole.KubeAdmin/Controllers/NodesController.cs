﻿using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using Microsoft.Extensions.Options;
using WhackAMole.KubeServices;
using WhackAMole.KubeServices.Models;
using WhackAMole.KubeServices.Providers;

namespace WhackAMole.KubeAdmin.Controllers
{
    [Produces("application/json")]
    [Route("api/[controller]")]
    public class NodesController : Controller
    {
        private readonly IAuthenticationProvider _auth;
        private readonly NodesRequest _nodesRequest;

        public NodesController(IAuthenticationProvider authProvider, IOptions<KubeOptions> options)
        {
            _auth = authProvider;
            var k8s = new KubeRequestBuilder(_auth, options.Value);
            _nodesRequest = k8s.Create<NodesRequest>();
        }

        // GET: api/values
        [HttpGet]
        public async Task<IActionResult> Get()
        {
            // try
            // {
                var list = await _nodesRequest.GetAllAsync();

                if (list == null || list.Length == 0)
                    return new NotFoundObjectResult(null);

                var nodes = new List<Node>();
                foreach (var node in list)
                    nodes.Add(new Node { Name = node.MetaData.Name, Uid = node.MetaData.Uid });

                return new OkObjectResult(nodes);
            // }
            // catch (Exception)
            // {
            //     return new NotFoundResult();
            // }
        }
    }
}
