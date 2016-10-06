server_manual <- function(input, output, session, session.data) {
  
  ###################################################################################################
  ######################################## "Manual" tab ###########################################  
  
  output$manual.1.1 <- renderUI(includeHTML('html/1_1.html'));
  output$manual.1.2 <- renderUI(includeHTML('html/1_2.html'));
  output$manual.2.1 <- renderUI(includeHTML('html/2_1.html'));
  output$manual.2.2 <- renderUI(includeHTML('html/2_2.html'));
  output$manual.2.3 <- renderUI(includeHTML('html/2_3.html'));
  output$manual.3.1 <- renderUI(includeHTML('html/3_1.html'));
  output$manual.3.2 <- renderUI(includeHTML('html/3_2.html'));
  output$manual.3.3 <- renderUI(includeHTML('html/3_3.html'));  
  output$manual.4.1 <- renderUI(includeHTML('html/4_1.html'));
  output$manual.4.2 <- renderUI(includeHTML('html/4_2.html'));
  output$manual.4.3 <- renderUI(includeHTML('html/4_3.html'));  
  
  session.data;
}