# ---------------------------------------------------------------------------------------------
# ------------------------------------------ preamble -----------------------------------------
# ---------------------------------------------------------------------------------------------
import numpy as np
import matplotlib as mpl
import matplotlib.pyplot as plt
import pandas as pd

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

# extra stuff
from matplotlib.ticker import FormatStrFormatter, ScalarFormatter
import math
from scipy.spatial import cKDTree  # For finding nearest neighbors

# formatting
formatter = ScalarFormatter(useMathText=True)
formatter.set_powerlimits((-2, 2))  # Sets limits for when to use scientific notation


# ---------------------------------------------------------------------------------------------
# ------------------------------------------ methods ------------------------------------------
# ---------------------------------------------------------------------------------------------
def fluidOverview(df, title, maxFluidSpeed=1e-3, maxMassDensity=1e-3):
#     df = df.query('coordinate_y <= 10 & coordinate_y >= -10')
    # figure preparation
#     fig, axes = plt.subplots(figsize = (5,2.5))
    fig, axes = plt.subplots(1, 2, figsize = (6,3))

#     fig.suptitle(f"$t = {df.time.values[0]:.2f}$", fontsize=16)
    fig.suptitle(title, fontsize=16)
    fig.subplots_adjust(right=0.875)  # Adjust the right space to make room for the colorbar


    # Create a meshgrid for plotting
    x_unique = df['coordinate_x'].unique()
    y_unique = df['coordinate_y'].unique()
    X, Y = np.meshgrid(x_unique, y_unique)
    
    xmax = x_unique.max()
    xmin = x_unique.min()
    ymax = y_unique.max()
    ymin = y_unique.min()

    # first plot
    upperLim = maxFluidSpeed
    lowerLim = 0.
    cmap = plt.get_cmap('cividis')
    norm = plt.Normalize(lowerLim, upperLim)

    axes[0].streamplot(X, Y, 
        df.fluidVelocity_x.unstack().values.transpose(),
        df.fluidVelocity_y.unstack().values.transpose(),
        density=0.85, linewidth=0.5, color="black",
    )
    
    
    axes[0].pcolormesh(X, Y,
        np.sqrt(df.fluidVelocity_x**2 + df.fluidVelocity_y**2).unstack().values.transpose(),
        vmin=lowerLim,
        vmax=upperLim,
        cmap=cmap, alpha = 0.85
    );
#     axes[0].tick_params(labelbottom=False)

    axes[0].set_xticks([xmin, 0,xmax])
    axes[0].set_xticklabels([f'{xmin:.0f}', 0,f'{xmax:.0f}'])
    axes[0].set_xlabel("$x ~ (\\mathrm{\\mu m})$")
    axes[0].set_yticks([ymin, 0, ymax])
    axes[0].set_yticklabels([f'{ymin:.0f}', 0,f'{ymax:.0f}'])
    axes[0].set_ylabel("$y ~ (\\mathrm{\\mu m})$")
    # axes[0].tick_params(labelbottom=False)
    
    cbar_ax = fig.add_axes([0.9, 0.55, 0.025, 0.3])  # [left, bottom, width, height] for the colorbar
#     cbar_ax = fig.add_axes([0.9, 0.15, 0.025, 0.7])  # [left, bottom, width, height] for the colorbar
    sm = plt.cm.ScalarMappable(cmap=cmap, norm=norm)
    sm.set_array([])
    cbar = fig.colorbar(sm, cax=cbar_ax, alpha=0.85)
    cbar.set_label(label='$\\mathbf{u}$', fontsize=16)
#     cbar.set_label(label='$|\\mathbf{u}| ~ \\left(10^{-3}~\\mathrm{mm}/\\mathrm{s}\\right)$', fontsize=16)
    cbar.ax.tick_params(labelsize=15)

    custom_ticks = np.array([lowerLim, upperLim/2, upperLim])
    cbar.set_ticks(custom_ticks)
    cbar.set_ticklabels([f'{tick:.4f}' for tick in custom_ticks])
#     cbar.set_ticklabels(['$0$','$1.5$','$3$'])
    
    # bottom plot
    squirmerRadius = 4;
    auxDf = df.query(f'coordinate_x**2 + coordinate_y**2 > {squirmerRadius}**2')
    # realEpsilon = np.max([np.abs(auxDf.massDensity.max() - 1), np.abs(auxDf.massDensity.min() - 1)])
    # epsilon = realEpsilon
#     epsilon = 10**(np.round(np.log(realEpsilon)/np.log(10)))
    epsilon = maxMassDensity
    upperLim = 1. + epsilon
    lowerLim = 1. - epsilon
    cmap = plt.get_cmap('seismic')
    norm = plt.Normalize(lowerLim, upperLim)
    axes[1].pcolormesh(X,Y,
        df.massDensity.unstack().values.transpose(),
        vmin=lowerLim,
        vmax=upperLim,
        cmap=cmap,
    );
    
    axes[1].set_xticks([xmin, 0,xmax])
    axes[1].set_xticklabels([f'{xmin:.0f}', 0,f'{xmax:.0f}'])
    axes[1].set_xlabel("$x ~ (\\mathrm{\\mu m})$")
    axes[1].set_yticks([ymin, 0, ymax])
    # axes[1].set_yticklabels([f'{ymin:.0f}', 0,f'{ymax:.0f}'])
    # axes[1].set_ylabel("$y ~ (\\mathrm{\\mu m})$")
    axes[1].tick_params(labelleft=False)

    cbar_ax = fig.add_axes([0.9, 0.13, 0.025, 0.3])  # [left, bottom, width, height] for the colorbar
    sm = plt.cm.ScalarMappable(cmap=cmap, norm=norm)
    sm.set_array([])
    cbar = fig.colorbar(sm, cax=cbar_ax)
    cbar.set_label(label='$\\rho$', fontsize=16)
    cbar.ax.tick_params(labelsize=15)

    custom_ticks = np.array([lowerLim, 1 ,upperLim])
    cbar.set_ticks(custom_ticks)
    cbar.set_ticklabels(custom_ticks)
    cbar.set_ticklabels([f'{tick:.3f}' for tick in custom_ticks])
    
    return fig, axes

def stressTensorOverview(df):
    # setting up stuff
    fig, axes = plt.subplots(2,2,figsize = (10,10))

    # Add a title for the whole figure
    fig.suptitle("$\\sigma_{ij}$", fontsize=16)

    # Create a meshgrid for plotting
    x_unique = df['coordinate_x'].unique()
    y_unique = df['coordinate_y'].unique()
    X, Y = np.meshgrid(x_unique, y_unique)

    cs = []

    # plotting
    c = axes[0,0].pcolormesh(X,Y,df["component_xx"].unstack().values.transpose()); cs.append(c);
    axes[0,0].set_title("$\\sigma_{xx}$")

    c = axes[0,1].pcolormesh(X,Y,df["component_xy"].unstack().values.transpose()); cs.append(c);
    axes[0,1].set_title("$\\sigma_{xy}$")

    c = axes[1,0].pcolormesh(X,Y,df["component_yx"].unstack().values.transpose()); cs.append(c);
    axes[1,0].set_title("$\\sigma_{yx}$")

    c = axes[1,1].pcolormesh(X,Y,df["component_yy"].unstack().values.transpose()); cs.append(c);
    axes[1,1].set_title("$\\sigma_{yy}$")


    # for ax in axes.flat:
    for i in range(4):
        ax = axes.flatten()[i]
        c = cs[i]
        ax.set_aspect('equal')
        ax.set_xlabel("$x$")
        ax.set_ylabel("$y$")    
        cbar = fig.colorbar(c, ax=ax, shrink=.8)
        cbar.ax.yaxis.set_major_formatter(formatter)
        cbar.ax.yaxis.get_offset_text().set_fontsize(10)  # Adjust the font size if necessary
    #     ax.axhline(wallPosition, color = "k", alpha = 0.1)
    #     ax.axhspan(-2, wallPosition, color='gray', alpha=0.1)  # Shade the wall
    
    return fig, axes

def particleTrjOverview(df):
    fig, axes = plt.subplots(1,2, figsize = (5,2.5))

    axes[0].plot(df.time, df.position_x, label='$x$')
    axes[0].plot(df.time, df.position_y, label='$y$')
    # axes[0].set_ylabel("$q$")

    axes[1].plot(df.time, df.velocity_x, label='$\\dot{x}$')
    axes[1].plot(df.time, df.velocity_y, label='$\\dot{y}$')
    # axes[1].set_ylabel("$\\dot{q}$")

    for i in range(len(axes)):
        ax = axes.flatten()[i]
        ax.set_xlabel("$t$")
        ax.yaxis.set_major_formatter(formatter)
        ax.legend()

    return fig, axes
