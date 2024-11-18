# ==========================================================================================
# ==========================================================================================
# preamble
# ==========================================================================================
# ==========================================================================================

# important stuff
import numpy as np
import matplotlib as mpl
import matplotlib.pyplot as plt
import pandas as pd
import os
import re
# extra stuff
from matplotlib.ticker import FormatStrFormatter, ScalarFormatter
import math

mpl.rc("figure", dpi=150)
mpl.rc("figure", figsize=(4,4))

plt.rcParams.update({
    "pgf.texsystem": "pdflatex",
    'font.family': 'serif',
    'text.usetex': True,
    'pgf.rcfonts': False,
    'xtick.labelsize':15,
    'ytick.labelsize':15,
    'axes.labelsize':20,
})

# formatting
formatter = ScalarFormatter(useMathText=True)
formatter.set_powerlimits((-2, 2))  # Sets limits for when to use scientific notation

# directory of the data is saved
src_n = os.path.basename(os.getcwd())
dataDir = f'../../data.lbm/{src_n}/'

# all ticks are found using regular expressions
pattern = r'fluidTrj_(\d+)\.csv'
files = os.listdir(dataDir)
ticks = []

for file in files:
    match = re.search(pattern, file)
    if match:
        ticks.append(int(match.group(1)))

ticks.sort()

# directory where files will be saved is created
outputDir = "frames.lbm"
os.mkdir(outputDir)
os.mkdir("anims")

# ==========================================================================================
# ==========================================================================================
# plotting
# ==========================================================================================
# ==========================================================================================

# the data is read
for tickId in np.arange(len(ticks)):
    fluidDf = pd.read_csv(dataDir + f"fluidTrj_{ticks[tickId]}.csv").set_index(["id_x","id_y"]).sort_index()

# the frame is created
    fig, axes = plt.subplots(1, 2, figsize = (10,5))

# Add a title for the whole figure
    fig.suptitle(f"$t = {fluidDf.time.values[0]}$", fontsize=16)

# Create a meshgrid for plotting
    x_unique = fluidDf['coordinate_x'].unique()
    y_unique = fluidDf['coordinate_y'].unique()
    X, Y = np.meshgrid(x_unique, y_unique)

    cs = []

    axes[0].streamplot(X, Y, 
        fluidDf.fluidVelocity_x.unstack().values.transpose(),
        fluidDf.fluidVelocity_y.unstack().values.transpose(),
        density=1.5, linewidth=0.5, color="black",
    )

    c = axes[0].pcolormesh(X, Y,
        np.sqrt(fluidDf.fluidVelocity_x**2 + fluidDf.fluidVelocity_y**2).unstack().values.transpose(),
        cmap = "viridis", alpha = 0.9
    ); cs.append(c);
    axes[0].set_title('fluid velocity')

    c = axes[1].pcolormesh(X,Y,
        fluidDf.massDensity.unstack().values.transpose(),
        vmin=min(fluidDf.query("massDensity > 0").massDensity.values),
        cmap = "viridis", alpha = 0.9
    ); cs.append(c);
    axes[1].set_title('mass density')

    for i in range(len(axes)):
        ax = axes.flatten()[i]
        c = cs[i]
        ax.set_aspect('equal')
        ax.set_xlabel("$x$")
        ax.set_ylabel("$y$")
        cbar = fig.colorbar(c, ax=ax, shrink=.8)
        cbar.ax.yaxis.set_major_formatter(formatter)
        cbar.ax.yaxis.get_offset_text().set_fontsize(10)  # Adjust the font size if necessary

    plt.savefig(f"{outputDir}/{tickId}.png", format="png")
    plt.close()

mkAnimSh = f'ffmpeg -loglevel quiet -framerate 5 -i {outputDir}/%d.png -c:v libx264 -pix_fmt yuv420p anims/output.mp4'
os.system(mkAnimSh)
os.system(f'rm -r {outputDir}')


# ffmpeg -loglevel quiet -framerate 5 -i frames.lbm/%d.png -c:v libx264 -pix_fmt yuv420p anims/output.mp4
