# Renomear as colunas automaticamente
colnames(balanco) <- stringr::str_remove(colnames(balanco), "^X")

nomes_correspondentes <- dicionario$nome_conta[match(names(balanco), dicionario$conta)]


colnames(balanco) <- ifelse(!is.na(nomes_correspondentes),
                            paste(names(balanco), nomes_correspondentes, sep = "_"),
                            names(balanco))

