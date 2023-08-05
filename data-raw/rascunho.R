# Renomear as colunas automaticamente
colnames(balanco) <- stringr::str_remove(colnames(balanco), "^X")

nomes_correspondentes <- dicionario$nome_conta[match(names(balanco), dicionario$conta)]


colnames(balanco) <- ifelse(!is.na(nomes_correspondentes),
                            paste(names(balanco), nomes_correspondentes, sep = "_"),
                            names(balanco))

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
