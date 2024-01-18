using Microsoft.AspNetCore.Mvc;
using System.Net;
using System.Text.Json.Serialization;

namespace MachineDetailsAPI.Controllers
{
        [ApiController]
        [Route("[controller]")]
        public class DetailsController : ControllerBase
        {
            [HttpGet]
            public IActionResult GetMachineDetails()
            {
                var machineName = Environment.MachineName;
                var machineIP = Dns.GetHostAddresses(Dns.GetHostName())[0].ToString();
                var machineOS = Environment.OSVersion.ToString();
                var timestamp = DateTime.Now.ToString();

                var machineDetails = new
                {
                    MachineName = machineName,
                    MachineIP = machineIP,
                    MachineOS = machineOS,
                    Timestamp = timestamp
                };

                return Ok(machineDetails);
            }
        }

}

