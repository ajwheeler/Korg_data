This the turbospectrum-format linelist used for APOGEE DR 17.  It is included as a built-in linelist
in Korg.  We store it here and ship a repackaged version in Korg because the water linelist is very 
large.  The "no_ba" atoms linelist has a Ba line with a nonexistent isotope removed.  It was
verified that changing it to the most abundant isotope has no discernable effect on spectra.

The README that was stored with the original data is below the break.

----

Turbospectrum 20:

 Turbospectrum20 includes the calculation of Stark broadening, which
was not available in the version of Turbospectrum (15.1) used for
previous data releases. As a result, the atomic linelist had to be modified to add an additional column for the Stark gamma. The values were adopted
from the APOGEE master line lists.  The inclusion of Stark broadening
changed the spectral synthesis of the Sun and Arcturus; based on
comparison of these syntheses with high resolution FTS spectra, log(gf),
vdW damping parameters, and a few Stark broadening parameteres were
adjusted for a few dozen lines to provide better fits.  Otherwise,
the atomic linelist was unchanged from DR16.

 Atomic lines:
   APOGEE master:
      linelist.20180901.txt has 51227 lines
   Turbospec format :
      turbospec.20180901.atoms has 50373 lines : 51227-50373=854 short, but does not have ionization states above III (831) or H lines (23)
      turbospec.20180901.Hlinedata has 133 lines (most outside of APOGEE window)
      format:
        wavelength, excitation potential, loggf, fdamp (vdw), gu, raddamp, gamma stark (per Fabio)

  Molecular (apart from H2O) lines:
   Turbospectrum20 requires an additional column in the molecular line lists, but otherwise
    these were unchanged from DR16
   Turbospectrum line lists include the isotopes explicitly, so isotope ratio is determined by input to turbospec run
   turbospec.20180901.molec :
       OH : 2550 16OH  lines
       FeH : 2782  lines
       C2 : 4216 12C12C  lines
       CN : 9815  =  5591 C12N14 + 4224 C14N14  lines
       CO : 29748 =  7478 12C16O + 7458 12C17O + 7401 12C18O + 7411 13C16O  lines

  Water lines
    For DR17, we switched from the Barber et al H2O linelist to the POKAZATEL
    linelists. We also added an additional cut so that there are 3 lists,
    cut at 8.5, 9.0, and 9.5eV
