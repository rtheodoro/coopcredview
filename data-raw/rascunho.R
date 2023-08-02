
balanco <- read.csv(app_sys("data/balanco_coop_cred_2010a2022_4010.csv"))
dicionario <- read.csv(app_sys("data/dicionario.CSV")) |> janitor::clean_names()

dicionario <- dicionario |>
   dplyr::mutate(conta = as.numeric(conta)) |>
   dplyr::filter(!is.na(conta)) |>
   unique()


colnames(balanco) <- gsub("^X", "", colnames(balanco))

nomes_correspondentes <- dicionario$nome_conta[match(names(balanco), dicionario$conta)]

# Renomear as colunas automaticamente
colnames(balanco) <- ifelse(!is.na(nomes_correspondentes),
                            paste(names(balanco), nomes_correspondentes, sep = "_"),
                            names(balanco))

#write.csv(balanco, "inst/data/balanco_coop_cred_2010a2022_4010.csv", row.names = FALSE)
balanco |>
   dplyr::filter(razao_social == "BOM CREDI") |>
   dplyr::mutate(ano = as.Date(sprintf("%s-%s-01", substr(ano, 1, 4), substr(ano, 5, 6)))) |>
   echarts4r::e_chart(x = ano) |>
   echarts4r::e_line(serie = `10000007_ATIVO REALIZ�VEL`)
