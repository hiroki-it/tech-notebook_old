// NOTE: TerraformでChatbotがサポートされていないため，エンドポイントをハードコーディングする．
output "aws_chatbot_endpoint" {
  value = "https://global.sns-api.chatbot.amazonaws.com"
}