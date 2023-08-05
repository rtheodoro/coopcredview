# Renomear as colunas automaticamente

balanco <- data.table::fread(app_sys("data/balanco_coop_cred_1993a2022_4010.csv"))


balanco <- balanco |>
   dplyr::mutate(ano = as.Date(sprintf("%s-%s-01", substr(ano, 1, 4), substr(ano, 5, 6))),
                 razao_social = iconv(razao_social,  "latin1", "UTF-8", "?"))
# |>
#    dplyr::filter(ano >= as.Date(sprintf("2010-12-01")))

balanco <- balanco  |>
   dplyr::group_by(cnpj)  |>
   dplyr::arrange(desc(ano))  |>
   dplyr::mutate(razao_social = dplyr::first(razao_social))  |>
   dplyr::ungroup()


dicionario <- data.table::fread(app_sys("data/dicionario.CSV"))  |> janitor::clean_names() |> dplyr::mutate(nome_conta = iconv(nome_conta,  "ASCII", "UTF-8", ""))


nomes_correspondentes <- dicionario$nome_conta[match(names(balanco), dicionario$conta)]

colnames(balanco) <- ifelse(!is.na(nomes_correspondentes),
                            paste(names(balanco), nomes_correspondentes, sep = "_"),
                            names(balanco))


ativas082023 <- read.csv(app_sys("data/202308_CoopCred_BCB_info_gerais.csv")) |> dplyr::select(cnpj)

balanco <- balanco |> dplyr::filter(cnpj %in% ativas082023$cnpj) |> janitor::clean_names()

write.csv(balanco, "inst/data/balanco_coop_cred_1993a2022_4010.csv", row.names = FALSE)

# Importando arquivos baixados ----
estrutGov <- read.csv(app_sys("data/202308_CoopCred_BCB_estrutura_governanca.csv"))


nomes_mulheres <- read.csv(app_sys("data/nomes.csv")) # csv baixando manualmente de um site com listas de nomes

nomes_mulheres <- nomes_mulheres |>
   dplyr::select(classification, first_name) |>
   dplyr::filter(classification == "F") |>
   dplyr::pull(first_name)

# Adicionando coluna de genero (M = Mulher, H = Homem)
estrutGov <- estrutGov |>
   dplyr::mutate(
      genero = dplyr::case_when(
         stringr::str_detect(nome,
                             stringr::str_c("^",
                                            stringr::str_c(nomes_mulheres, collapse = "\\s+|^"),
                                            "^")) ~ "M",
         TRUE ~ "H"
      ),
      cargo = stringr::str_replace(cargo, "-", " ")
   ); rm(nomes_mulheres)

write.csv(estrutGov, app_sys("data/202308_CoopCred_BCB_estrutura_governanca.csv"), row.names = FALSE)
