import pandas as pd
import matplotlib.pyplot as plt
import seaborn as sns
import matplotlib.ticker as ticker

# 1. Datos reales (Filtrados solo para SPAdes)
data = {
    'ID': ['SRR34971513','SRR34971512','SRR34971508','SRR34971509','SRR34971511',
           'SRR34971514','SRR34971516','SRR34971515','SRR34971510'],
    'Total': [752624, 694493, 545215, 526213, 1551152, 569655, 1690227, 617312, 691628],
    'Completos': [113281, 87052, 98014, 81430, 186214, 115047, 181013, 92824, 124278]
}

df = pd.DataFrame(data)

# 2. Mapeo de Municipios
municipios = {
    'SRR34971508': 'Salento 2', 'SRR34971509': 'Armenia', 'SRR34971510': 'Montenegro',
    'SRR34971511': 'Filandia', 'SRR34971512': 'Circasia 2', 'SRR34971513': 'Génova',
    'SRR34971514': 'Quimbaya', 'SRR34971515': 'Circasia 1', 'SRR34971516': 'Salento 1'
}
df['Municipio'] = df['ID'].map(municipios)

# Ordenar de mayor a menor para que la gráfica tenga un flujo visual claro
df = df.sort_values('Total', ascending=False)

# 3. Creación de la Gráfica
plt.figure(figsize=(16, 6))
sns.set_style("white") # Estilo limpio para póster

# Barra de Total (Gris claro)
plt.bar(df['Municipio'], df['Total'], color='#dee2e6', label='Genes Truncados/Parciales')

# Barra de Completos (Azul vibrante para resaltar)
plt.bar(df['Municipio'], df['Completos'], color='#1f77b4', label='Genes Completos')

# 4. Añadir etiquetas de porcentaje y formato de ejes
for i, row in enumerate(df.itertuples()):
    pct = (row.Completos / row.Total) * 100
    plt.text(i, row.Total + 20000, f'{pct:.1f}%', ha='center', va='bottom', 
             fontsize=12, fontweight='bold', color='#1f77b4')

# Formatear Eje Y a Millones (M)
ax = plt.gca()
ax.yaxis.set_major_formatter(ticker.FuncFormatter(lambda x, p: f'{x/1e6:.1f}M'))

# Títulos y etiquetas
plt.title('Genes Codificantes (MetaSPAdes)', fontsize=16, fontweight='bold', pad=20)
plt.ylabel('Número de Genes (Millones)', fontsize=12)
plt.xticks(rotation=45, ha='right', fontsize=12)
plt.legend(frameon=False, loc='upper right')

# Quitar bordes innecesarios (estética moderna)
sns.despine()

plt.tight_layout()
plt.savefig('prodigal_spades_quindio.svg', format='svg', bbox_inches='tight') # Formato ideal para impresión
plt.show()
