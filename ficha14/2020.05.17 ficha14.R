# Ficha 14

library( neuralnet ) # biblioteca de RNAs
library( hydroGOF )  # biblioteca de fun??es estat?sticas
library( arules )    # biblioteca de an?lise de dados
library( leaps )     # biblioteca de prepara??o de dados

set.seed( 1234567890 )

#setwd("C:/DataPjon/Aulas/2019-20/SRCR/TPs/Aula PL/PL3/05.21/fichas_resolucao_r")

# ler dataset de um ficheiro csv
dados <- read.csv("creditset.csv")

# mostrar a "cabe?a" do dataset
head(dados)

# dividir os dados iniciais em casos para treino...
treino <- dados[1:800, ]

# ... e casos para teste:
teste <- dados[801:2000, ]

# sele??o de vari?veis mais significativas
funcao01 <- default10yr ~ income+age+loan+LTI
selecao01 <- regsubsets(funcao01,dados,nvmax=3)
summary(selecao01)

funcao02 <- default10yr ~ clientid+income+age+loan+LTI
selecao02 <- regsubsets(funcao02,dados,method="backward")
summary(selecao02)

# discretiza??o de atributos
nomes <- c(1,2,3,4,5)
income <- discretize(dados$income,method = "frequency",categories = 5,labels = nomes )
dados$income <- as.numeric(income)

income <- discretize(dados$income,method = "cluster",categories = 4,labels = c(1,2,3,4) )
dados$income <- as.numeric(income)

# defini??o das camadas de entrada e sa?da da RNA
formula01 <- default10yr ~ LTI + age


# treinar a rede neuronal com default10yr como output
rnacredito <- neuralnet( formula01, treino, hidden = c(4), lifesign = "full", linear.output = FALSE, threshold = 0.1)


rede <- neuralnet( formula02, treino, hidden = c(3,2), threshold = 0.1)

# desenhar rede neuronal
plot(rnacredito, rep = "best")
plot(rede)

# definir variaveis de input para teste
teste.01 <- subset(teste, select = c("LTI", "age"))

# testar a rede com os novos casos
rnacredito.resultados <- compute(rnacredito, teste.01)

# imprimir resultados
resultados <- data.frame(atual = teste$default10yr, previsao = rnacredito.resultados$net.result)

# imprimir resultados arrendondados
resultados$previsao <- round(resultados$previsao, digits=0)

# calcular o RMSE
rmse(c(teste$default10yr),c(resultados$previsao))


# Nova rede com 3 nodos de entrada age+loan+LTI
formula02 <- default10yr ~ age+loan+LTI

# treinar a rede neuronal com default10yr como output
rede <- neuralnet( formula02, treino, hidden = c(3,2), threshold = 0.1)

# desenhar rede neuronal
plot(rede)

# definir variaveis de input para teste
teste.01 <- subset(teste, select = c("age", "loan", "LTI" ))

# testar a rede com os novos casos
rede.resultados2 <- compute(rede, teste.01)

# imprimir resultados
resultados2 <- data.frame(atual = teste$default10yr, previsao = rede.resultados2$net.result)

# imprimir resultados arrendondados
resultados2$previsao <- round(resultados2$previsao, digits=0)

# calcular o RMSE
rmse(c(teste$default10yr),c(resultados2$previsao))



