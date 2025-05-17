public class ContratoTestCallout {

    public static void bulkifyCallout(Set<Id> listaId) {
        if (!listaId.isEmpty() && listaId.size() < (Limits.getLimitCallouts() - Limits.getCallouts())) {
            enviarContratoTest(new List<Id>(listaId));
        }
    }

    @future (callout = true)
    public static void enviarContratoTest(List<Id> listaId) {
        // Usa la nueva URL de ngrok

        List<Contract> lContract = new List<Contract>();

        if(listaId.size() > 0){
            lContract = [SELECT Id, Account.Name, ContractNumber, Status, StartDate FROM Contract WHERE Id IN :listaId];
        }


        String endpoint = 'https://feac-2a03-4460-1227-d600-14d3-c131-8a1d-f187.ngrok-free.app/pedido';

        // Crea la petición HTTP
        HttpRequest req = new HttpRequest();
        req.setEndpoint(endpoint);  // La URL de tu servidor Flask expuesto
        req.setMethod('POST');
        req.setHeader('Content-Type', 'application/json');

        for(Contract c : lContract){
            // Crea el cuerpo de la solicitud (JSON)
            Map<String, String> datosContrato = new Map<String, String>{
                'Cuenta Asociada' => c.Account.Name,
                'Número de Contrato' => c.ContractNumber,
                'Status' => c.Status,
                'Fecha de Inicio' => c.StartDate.toString()
            };

            // Serializa el cuerpo en formato JSON
            req.setBody(JSON.serialize(datosContrato));

            // Envia la solicitud
            Http http = new Http();
            HttpResponse res = http.send(req);

            // Verifica la respuesta
            System.debug('Respuesta del servidor: ' + res.getBody());
        }
        
    }
}