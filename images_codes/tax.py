import pandas as pd
import matplotlib.pyplot as plt
import seaborn as sns
import io

# 1. Cargar los datos
raw_data = """Sample,Domain,Count
MEGAHIT-SRR34971508,Bacteria,7467
MEGAHIT-SRR34971508,Eukarya,2113
MEGAHIT-SRR34971508,Archaea,254
MEGAHIT-SRR34971508,Unknown,58
MEGAHIT-SRR34971509,Bacteria,5692
MEGAHIT-SRR34971509,Eukarya,2951
MEGAHIT-SRR34971509,Archaea,296
MEGAHIT-SRR34971509,Unknown,50
MEGAHIT-SRR34971510,Bacteria,7407
MEGAHIT-SRR34971510,Eukarya,5313
MEGAHIT-SRR34971510,Archaea,484
MEGAHIT-SRR34971510,Unknown,104
MEGAHIT-SRR34971511,Bacteria,12112
MEGAHIT-SRR34971511,Eukarya,2894
MEGAHIT-SRR34971511,Archaea,315
MEGAHIT-SRR34971511,Unknown,82
MEGAHIT-SRR34971512,Bacteria,7075
MEGAHIT-SRR34971512,Eukarya,1688
MEGAHIT-SRR34971512,Archaea,100
MEGAHIT-SRR34971512,Unknown,43
MEGAHIT-SRR34971513,Bacteria,7367
MEGAHIT-SRR34971513,Eukarya,4273
MEGAHIT-SRR34971513,Archaea,96
MEGAHIT-SRR34971513,Unknown,57
MEGAHIT-SRR34971514,Bacteria,8606
MEGAHIT-SRR34971514,Eukarya,3960
MEGAHIT-SRR34971514,Archaea,60
MEGAHIT-SRR34971514,Unknown,24
MEGAHIT-SRR34971515,Bacteria,6687
MEGAHIT-SRR34971515,Eukarya,2911
MEGAHIT-SRR34971515,Archaea,411
MEGAHIT-SRR34971515,Unknown,75
MEGAHIT-SRR34971516,Bacteria,10174
MEGAHIT-SRR34971516,Eukarya,6409
MEGAHIT-SRR34971516,Archaea,500
MEGAHIT-SRR34971516,Unknown,117
SPAdes-SRR34971508,Bacteria,5756
SPAdes-SRR34971508,Eukarya,1767
SPAdes-SRR34971508,Archaea,240
SPAdes-SRR34971508,Unknown,59
SPAdes-SRR34971509,Bacteria,5389
SPAdes-SRR34971509,Eukarya,2686
SPAdes-SRR34971509,Archaea,236
SPAdes-SRR34971509,Unknown,44
SPAdes-SRR34971510,Bacteria,6635
SPAdes-SRR34971510,Eukarya,4024
SPAdes-SRR34971510,Archaea,381
SPAdes-SRR34971510,Unknown,83
SPAdes-SRR34971511,Bacteria,11099
SPAdes-SRR34971511,Eukarya,2332
SPAdes-SRR34971511,Archaea,312
SPAdes-SRR34971511,Unknown,63
SPAdes-SRR34971512,Bacteria,6745
SPAdes-SRR34971512,Eukarya,1199
SPAdes-SRR34971512,Archaea,81
SPAdes-SRR34971512,Unknown,40
SPAdes-SRR34971513,Bacteria,6872
SPAdes-SRR34971513,Eukarya,3558
SPAdes-SRR34971513,Archaea,68
SPAdes-SRR34971513,Unknown,52
SPAdes-SRR34971514,Bacteria,7265
SPAdes-SRR34971514,Eukarya,3629
SPAdes-SRR34971514,Archaea,62
SPAdes-SRR34971514,Unknown,28
SPAdes-SRR34971515,Bacteria,5649
SPAdes-SRR34971515,Eukarya,2472
SPAdes-SRR34971515,Archaea,306
SPAdes-SRR34971515,Unknown,62
SPAdes-SRR34971516,Bacteria,9517
SPAdes-SRR34971516,Eukarya,5915
SPAdes-SRR34971516,Archaea,438
SPAdes-SRR34971516,Unknown,86"""

df = pd.read_csv(io.StringIO(raw_data)) # Sustituir por tu archivo csv si prefieres

# 2. Limpieza: Separar Ensamblador y Muestra, y mapear a Municipios
map_municipios = {
    'SRR34971508': 'Salento2', 'SRR34971509': 'Armenia', 'SRR34971510': 'Montenegro',
    'SRR34971511': 'Filandia', 'SRR34971512': 'Circasia2', 'SRR34971513': 'Génova',
    'SRR34971514': 'Quimbaya', 'SRR34971515': 'Circasia', 'SRR34971516': 'Salento'
}
orden_municipios = list(map_municipios.values())


df['Assembler'] = df['Sample'].apply(lambda x: x.split('-')[0])
df['ID'] = df['Sample'].apply(lambda x: x.split('-')[1])
df['Municipio'] = df['ID'].map(map_municipios)

df['Municipio'] = pd.Categorical(df['Municipio'], categories=orden_municipios, ordered=True)

# 3. Calcular porcentajes para la gráfica 100% apilada
pivot_df = df.pivot_table(index=['Municipio', 'Assembler'], columns='Domain', values='Count',sort=False).fillna(0)
perc_df = pivot_df.div(pivot_df.sum(axis=1), axis=0) * 100

# 4. Configuración de la gráfica
sns.set_theme(style="white", context="talk")
fig, ax = plt.subplots(figsize=(16, 8))

# Colores sugeridos: Bacterias (Azul), Eukarya (Verde/Hoja), Archaea (Rojo tierra), Unknown (Gris)
colores = ['#4C72B0', '#81B622', '#C94C4C', '#8E8E8E']

perc_df.plot(kind='bar', stacked=True, ax=ax, color=colores, width=0.8)

# 5. Personalización estética
plt.title('Distribución Taxonómica por Dominio (Tiara)', fontsize=20, fontweight='bold', pad=25)
plt.ylabel('Proporción de Contigs (%)', fontsize=14, fontweight='bold')
plt.xlabel('Localidad y Ensamblador', fontsize=14, fontweight='bold')
plt.xticks(rotation=45, ha='right', fontsize=10)
plt.legend(loc='upper center', 
    bbox_to_anchor=(0.5, -0.4), 
    ncol=4, 
    fontsize=12, 
    title_fontsize=11,
    frameon=False)

# Ajustar límites y quitar bordes innecesarios
plt.ylim(0, 100)
sns.despine()

plt.tight_layout()
plt.savefig('tiara_domains_100percent.svg',format='svg') # Formato vectorial
plt.show()
