import pandas as pd
import matplotlib.pyplot as plt
import seaborn as sns

# 1. Preparación de los datos basándonos en tu tabla
data = {
    'Origen': ['Salento2', 'Armenia', 'Montenegro', 'Filandia', 'Circasia2', 'Génova', 'Quimbaya', 'Circasia', 'Salento'],
    'MH_N50': [2200, 1612, 2160, 1461, 1554, 1980, 2468, 1769, 1285],
    'MS_N50': [3574, 2460, 5258, 1593, 2384, 2841, 3661, 3224, 1522],
    'MH_Len': [216.7, 192.12, 266.05, 394.6, 187.9, 238.8, 243.5, 215.3, 425.86],
    'MS_Len': [171.9, 157.7, 209.5, 367.05, 157.45, 209.9, 204.8, 163.7, 392.01]
}

df = pd.DataFrame(data)

# Reestructurar para Seaborn (formato largo)
df_n50 = df.melt(id_vars='Origen', value_vars=['MH_N50', 'MS_N50'], 
                 var_name='Ensamblador', value_name='N50')
df_n50['Ensamblador'] = df_n50['Ensamblador'].map({'MH_N50': 'MEGAHIT', 'MS_N50': 'MetaSPAdes'})

# 2. Configuración de la gráfica
sns.set_theme(style="white", context="talk")
fig, ax1 = plt.subplots(figsize=(16, 6))

# --- EJE 1: BARRAS PARA N50 ---
colores = ['#4C72B0', '#DD8452'] # Azul y Naranja mate profesional
sns.barplot(data=df_n50, x='Origen', y='N50', hue='Ensamblador', ax=ax1, palette=colores, alpha=0.8)

ax1.set_ylabel('N50 (bp)', fontsize=14, fontweight='bold', color='#333333')
ax1.set_xlabel('', fontsize=1, fontweight='bold')
ax1.legend(title='Ensamblador (N50)', loc='upper left',fontsize=13,title_fontsize=14, frameon=True)
ax1.tick_params(axis='x',labelsize=11, rotation=45)

# --- EJE 2: PUNTOS/LÍNEAS PARA TOTAL LENGTH ---
ax2 = ax1.twinx() # Crear el segundo eje
# Graficamos el Total Length de MEGAHIT
sns.lineplot(x=df['Origen'], y=df['MH_Len'], marker='o', color='#2b456e', label='Len MEGAHIT (Mb)', ax=ax2, linewidth=2, markersize=8)
# Graficamos el Total Length de MetaSPAdes
sns.lineplot(x=df['Origen'], y=df['MS_Len'], marker='s', color='#9e5225', label='Len MetaSPAdes (Mb)', ax=ax2, linewidth=2, markersize=8)

ax2.set_ylabel('Total Length (Mb)', fontsize=14, fontweight='bold', color='#2b456e')
ax2.legend(title='Longitud Total', loc='upper right', bbox_to_anchor=(0.75, 1),fontsize=13,title_fontsize=14, frameon=True)
ax2.grid(False) # Quitar el grid del segundo eje para que no se ensucie la gráfica

# 3. Toques finales para el póster
plt.title('Desempeño de Ensambladores por Muestra', fontsize=18, fontweight='bold', pad=20)
fig.tight_layout()

# Guardar
plt.savefig('grafica_ensamblaje_HQ.svg',format='svg')
plt.show()

print("¡Gráfica generada! Las barras muestran la continuidad (N50) y los puntos la diversidad total (Mb).")

