import { Handler, APIGatewayProxyEvent, APIGatewayProxyResult } from "aws-lambda"

export const checkMyIp: Handler = async (event: APIGatewayProxyEvent): Promise<APIGatewayProxyResult> => {
  return {
    statusCode: 200,
    headers: {
      "Content-Type": "text/plain"
    },
    body: event?.requestContext?.identity?.sourceIp
  }
}
