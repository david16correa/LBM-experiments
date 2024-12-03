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

# figure preparation
    fig, axes = plt.subplots(2, 1, figsize = (9,3.))

    fig.suptitle(f"$t = {fluidDf.time.values[0]:.0f}$", fontsize=16)
    fig.subplots_adjust(right=0.875)  # Adjust the right space to make room for the colorbar


# Create a meshgrid for plotting
    x_unique = fluidDf['coordinate_x'].unique()
    y_unique = fluidDf['coordinate_y'].unique()
    X, Y = np.meshgrid(x_unique, y_unique)

# top plot
    upperLim = 0.003
    lowerLim = 0.
    cmap = plt.get_cmap('cividis')
    norm = plt.Normalize(lowerLim, upperLim)

    axes[0].streamplot(X, Y, 
        fluidDf.fluidVelocity_x.unstack().values.transpose(),
        fluidDf.fluidVelocity_y.unstack().values.transpose(),
        density=1.5, linewidth=0.5, color="black",
    )
    axes[0].pcolormesh(X, Y,
        np.sqrt(fluidDf.fluidVelocity_x**2 + fluidDf.fluidVelocity_y**2).unstack().values.transpose(),
        vmin=lowerLim,
        vmax=upperLim,
        cmap=cmap, alpha = 0.8
    );
    axes[0].tick_params(labelbottom=False)
    axes[0].set_ylabel("$y$")

    cbar_ax = fig.add_axes([0.9, 0.55, 0.02, 0.3])  # [left, bottom, width, height] for the colorbar
    sm = plt.cm.ScalarMappable(cmap=cmap, norm=norm)
    sm.set_array([])
    cbar = fig.colorbar(sm, cax=cbar_ax, alpha=0.8)
    cbar.set_label(label='$\\mathbf{u}$', fontsize=16)
    cbar.ax.tick_params(labelsize=15)

    custom_ticks = np.array([lowerLim, upperLim/2, upperLim])
    cbar.set_ticks(custom_ticks)
    cbar.set_ticklabels([f'{tick:.3f}' for tick in custom_ticks])

# bottom plot
    upperLim = 1.01
    lowerLim = 0.99
    cmap = plt.get_cmap('seismic')
    norm = plt.Normalize(lowerLim, upperLim)
    axes[1].pcolormesh(X,Y,
        fluidDf.massDensity.unstack().values.transpose(),
        vmin=lowerLim,
        vmax=upperLim,
        cmap=cmap,
    );
    axes[1].set_xlabel("$x$")
    axes[1].set_ylabel("$y$")

    cbar_ax = fig.add_axes([0.9, 0.13, 0.02, 0.3])  # [left, bottom, width, height] for the colorbar
    sm = plt.cm.ScalarMappable(cmap=cmap, norm=norm)
    sm.set_array([])
    cbar = fig.colorbar(sm, cax=cbar_ax)
    cbar.set_label(label='$\\rho$', fontsize=16)
    cbar.ax.tick_params(labelsize=15)

    custom_ticks = np.array([lowerLim, 1 ,upperLim])
    cbar.set_ticks(custom_ticks)
    cbar.set_ticklabels(custom_ticks)
    cbar.set_ticklabels([f'{tick:.2f}' for tick in custom_ticks])

    plt.savefig(f"{outputDir}/{tickId}.png", format="png")
    plt.close()

mkAnimSh = f'ffmpeg -loglevel quiet -framerate 5 -i {outputDir}/%d.png -c:v libx264 -pix_fmt yuv420p anims/output.mp4'
os.system(mkAnimSh)
os.system(f'rm -r {outputDir}')


# ffmpeg -loglevel quiet -framerate 5 -i frames.lbm/%d.png -c:v libx264 -pix_fmt yuv420p anims/output.mp4
