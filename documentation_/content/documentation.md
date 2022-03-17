---
title: "IMU-Daten einer Trajektorie"
date: \today
author: "Christoph Kurz"
bibliography: "bibliography.bib"
link-citations: true
urlcolor: "blue"
geometry: margin=2cm
---

\newpage

# Anwendung

Im Folgenden soll ein Matlab-Tool vorgestellt werden, das es ermöglicht, anhand einer vorgegebenen Trajektorie und einer vorgegebenen Orientierung die Ausgangsdaten einer IMU (Inertialen Messeinheit) zu simulieren.
Die Vorgabe der Trajektorie $\vec{s}(t)$ und der Orientierung $\vec{\varphi}(t)$ soll mithilfe einer Funktion (zur symbolischen Berechnung) und mithilfe eines Vektors (zur nummerischen Berechnung) möglich sein:

Vorgabe mithilfe von Funktionen:

```Matlab
% Trajektorie als Funktion
sx = @(t) (0.8 .* cos(2*pi*f*t)); % m
sy = @(t) (0.8 .* sin(2*pi*f*t)); % m
sz = @(t) (0.3 .* cos(2*pi*3*f*t)); % m

% Orientierung als Funktion
phix = @(t) (0 .* t); % rad
phiy = @(t) (0 .* t); % rad
phiz = @(t) (0 .* t); % rad
``` 
Vorgabe mithilfe von Vektoren:

```Matlab
% Zeit Vektor
t = (0 : 0.01 : 5); % s

% Trajektorie als Vektor
sx = (0.8 .* cos(2*pi*f*t)); % m
sy = (0.8 .* sin(2*pi*f*t)); % m
sz = (0.3 .* cos(2*pi*3*f*t)); % m

% Orientierung als Vektor
phix = (0 .* t); % rad
phiy = (0 .* t); % rad
phiz = (0 .* t); % rad
``` 

Entlang dieser Vorgegebenen Trajektorie bewegt sich der Schwerpunkt $S$ eines starren Körpers.
Die Inertiale Messeinheit ist dabei im Abstand $\vec{r}$ vom Schwerpunkt entfernt.

```Matlab
r = [-75e-3, -75e-3, 25e-3]; % m
``` 

Um dies zu Verdeutlichen wird in der Abbildung \ref{fig:trajectory} die oben definierte Trajektorie abgebildet. 

![Beispiel einer Trajektorie mit einer IMU \label{fig:trajectory}](img/01_trajectory/trajectory.pdf)

Hierbei wird der starre Körper als rotes Dreieck dargestellt das sich entlang der Trajektorie fortbewegt.
Die Orientierung des starren Körpers wurde so gewählt, dass er sich entlang des Tangentialvektors der Trajektorie ausrichtet.
Der Schwerpunkt und die Position der IMU werden mit einem gelben und violetten Punkt markiert.

\newpage

# Grundlagen
Bevor näher auf die Algorithmen eingegangen wird, werdend die Grundlagen beschrieben, die im Weiteren von Bedeutung sind. 
Hierbei sind der Weg $\vec{s}$ und die Orientierung $\vec{\varphi}$ von Bedeutung.
Daraus ergeben sich 6 Freiheitsgrade, damit Position und Lage eines Körpers im Raum beschrieben werden kann.
Weiters sind die folgenden Ableitungen dieser Größen von Bedeutung:

* die Geschwindigkeit $\vec{v} = \dot{\vec{s}}$
* die Winkelgeschwindigkeit $\vec{\omega} = \dot{\vec{\varphi}}$
* die lineare Beschleunigung $\vec{a} = \dot{\vec{v}}$
* die Winkelbeschleunigung $\vec{\alpha} = \dot{\vec{\omega}}$
  
Wobei $\dot{(\cdot)}$ die zeitliche Ableitung kennzeichnet.
Die beschriebenen Größen lassen sich in lineare Größen (Weg $\vec{s}$, Geschwindigkeit $\vec{v}$, lineare Beschleunigung $\vec{a}$) und in Drehgrößen (Orientierung $\vec{\varphi}$, Winkelgeschwindigkeit $\vec{\omega}$, Winkelbeschleunigung $\vec{\alpha}$) unterteilen. 


## Orientierung im dreidimensionalen Raum mithilfe von Euler-Winkeln und Drehmatrizen
Um die Orientierung von Körpern zu beschreiben werden Euler-Winkel verwendet.
Aus diesen können Drehmatrizen gewonnen werden, die eine Rotation des Koordinatensystem (eine Änderung der Orientierung) ermöglichen.
Dazu müssen verschiedenen Koordinatensysteme eingeführt werden:

* Inertialsystem $\mathbb{N}$
* Körperkoordinatensystem $\mathbb{B}$

Das Inertialsystem wird nach ENU-Konvention definiert.
ENU bedeutet East, North, Up (also Osten, Norden, oben) und beschreibt die Richtung der Koordinaten-Achsen (Osten $= x$, Norden $= y$ und oben $= z$).
Die Körperkoordinatensysteme beschreibt das Koordinatensystem des starren Körpers.

### Euler-Winkel
Die Euler-Winkel beschreiben die Drehlage/Orientierung eines Körpers durch 3 Winkel $\varphi_x$, $\varphi_y$ und $\varphi_z$ der jeweiligen Achse. 
Zusammen beschreiben sie den Vektor $\vec{\varphi}$:
$$
	\vec{\varphi} = 
	\begin{bmatrix}
		\varphi_x \\
		\varphi_y \\
		\varphi_z \\
	\end{bmatrix}
$$
Es wird unterschieden zwischen den klassischen Euler-Winkeln und den Tait-Bryan-Winkeln, wobei diese wieder in unterschiedliche Konventionen eingeteilt werden können.

![Darstellung der Tait-Bryan-Winkel nach z-y-x (intrinsisch) Konvention \label{fig:euler_ang}](img/02_eulerangle/eulerangle.pdf)

Die am häufigsten verwendete Konvention ist die $z$-$y$-$x$-Konvention (intrinsische Konvention), wobei $z$-$y$-$x$ die Reihenfolge der zu drehenden Achsen definiert. 
Intrinsisch bedeutet, dass jeweils um die neu entstehende Achse gedreht wird.
Abbildung \ref{fig:euler_ang} zeigt schrittweise wie mit dieser Konvention Koordinatensysteme gedreht werden.
Im Gegensatz zu intrinsischen Drehungen werden extrinsische Drehungen um die Achse des alten Koordinatensystems gedreht. 
Jede intrinsische Drehung kann in eine extrinsische Drehung umgewandelt werden und vice versa.
Die Drehung $z$-$y$-$x$ ist beispielsweise intrinsisch äquivalent mit der extrinsischen $x$-$y$-$z$-Drehung.

### Drehmatrix
Eine andere Möglichkeit, die Euler-Winkel zu manipulieren, ist die Drehmatrix.
Sie ergibt sich aus der Multiplikation dreier Matrizen, die eine Rotation um die jeweilige Koordinaten-Achse beschreiben:
$$
	\mathbf{R}(\vec{\varphi}) =
	\underbrace{ 
		\begin{bmatrix}
			\cos(\varphi_z) & -\sin(\varphi_z) & 0 \\
			\sin(\varphi_z) &  \cos(\varphi_z) & 0 \\
			0            & 0             & 1 \\
		\end{bmatrix}
	}_{\mathbf{R_z}(\varphi_z)} \cdot
	\underbrace{   
		\begin{bmatrix}
			\cos(\varphi_y) & 0 & \sin(\varphi_y)   \\
			0            & 1 & 0              \\
		-\sin(\varphi_y) & 0 & \cos(\varphi_y)   \\
		\end{bmatrix}
	}_{\mathbf{R_y}(\varphi_y)} \cdot
	\underbrace{ 
		\begin{bmatrix}
			1 &  0            & 0              \\
			0 &  \cos(\varphi_x) & -\sin(\varphi_x)  \\
			0 &  \sin(\varphi_x) & \cos(\varphi_x)   
		\end{bmatrix}
	}_{\mathbf{R_x}(\varphi_x)}
$$
Um einen Vektor vom Inertialsystem $\mathbb{N}$ in das Körpersystem $\mathbb{B}$ (Rotation des Punktes) zu transformieren, wird der zu rotierende Vektor $\vec{v}_{\mathbb{N}} = (v_x, v_y, v_z)^T$ mit der Drehmatrix $\mathbf{R}(\vec{\varphi})$ multipliziert:
$$
	\vec{v}_{\mathbb{B}} = \mathbf{R}(\vec{\varphi}) \cdot \vec{v}_{\mathbb{N}}
$$
Die Indizes geben dabei das Koordinatensystem des jeweiligen Vektors an.
Soll ein Vektor vom Körpersystem in das Inertialsystem (Rotation des Koordinatensystems) transformiert werden, muss der zu rotierende Vektor mit der inversen Drehmatrix multipliziert werden:
$$
	\vec{v}_{\mathbb{B}} = \left(\mathbf{R}(\vec{\varphi})\right)^{-1} \cdot \vec{v}_{\mathbb{N}}
$$

## Bestimmung der abgeleiteten Größen
Um die Geschwindigkeit oder die Beschleunigung zu bestimmen muss der Weg durch Differenzieren nach der Zeit bestimmt werden:

$$\vec{v}(t) = \frac{\mathrm{d}\vec{s}(t)}{\mathrm{d} t}$$
$$\vec{a}(t) = \frac{\mathrm{d}\vec{v}(t)}{\mathrm{d} t}$$

Die Winkelgeschwindigkeit wird nicht über die Euler-Winkel, sondern über die Rotationsmatrix bestimmt:

$$
\begin{bmatrix}
     0           & -\omega_z(t) &  \omega_y(t) \\
     \omega_z(t) & 0            & -\omega_x(t) \\
    -\omega_y(t) & \omega_x(t)  &  0           \\
\end{bmatrix} = 
\mathbf{\Omega}(t) = \frac{\mathrm{d} \mathbf{R}(t)}{\mathrm{d} t} \mathbf{R}(t)^{-1}
$$

Anschließend kann die Winkelbeschleunigung mit anschließendem differenzieren gewonnen werden:

$$
\vec{\alpha}(t) = \frac{\mathrm{d}\vec{\omega}(t)}{\mathrm{d} t}
$$
 
Mit Matlab kann die Differentiation sowohl symbolisch (mit der Symbolic Math Toolbox) als auch nummerisch (mit der Funktion `x_ = gradient(x,t)`) durchgeführt werden

## Mechanische Grundlagen
Um die Daten der IMU (am Punkt $I$) anhand der Größen am Schwerpunkt $S$ zu bestimmen, kann folgende kinematische Beziehung angewandt werden:
$$
	\vec{a_I}(t) = \vec{a_S}(t) + \vec{\omega}(t) \times \left( \vec{\omega}(t) \times \vec{r} \right) + \vec{\alpha}(t) \times \vec{r}
$$
Die einzelnen Größen können folgendermaßen interpretiert werden:

* $\vec{a_S}$ ist die Beschleunigung im Schwerpunkt $S$ und setzt sich aus Gravitationsbeschleunigung $\vec{g}$ und linearer Beschleunigung $\vec{a_\mathrm{l}}$ zusammen.
* $\vec{\omega}(t) \times \left( \vec{\omega}(t) \times \vec{r} \right)$ entspricht der Zentrifugalbeschleunigung $\vec{a_\mathrm{c}}$, die durch die Drehung des starren Körpers entsteht.
* $\vec{\alpha}(t) \times \vec{r}$ entspricht der Euler-Kraft und entsteht durch eine beschleunigte Drehung des starren Körpers mit der Winkelbeschleunigung $\vec{\alpha}(t)$.
* $\vec{a_I}$ ist die resultierende Beschleunigung an der Punkt der IMU.

\newpage

# Funktionen
Im Nachfolgendem werden die einzelnen Funktionen beschrieben, um Daten einer IMU zu bestimmen und darzustellen.

## Lineare Größen `my_lin`

Mit der Funktion `my_lin` werden die lineare Geschwindigkeit $\vec{v}(t)$ und lineare Beschleunigung $\vec{a}(t)$ anhand der Trajektorie $\vec{s}(t)$ bestimmt.
Dazu werden die Gleichungen xx und xx angewandt.

### Syntax
`[s_calc, v_calc, a_calc] = my_lin(s, option, t_)`

### Parameter
* `s` 3D-Vektor oder Cell mit 3 Vektorfunktionen der Trajektorie
* `option` String: `'num'` oder `'sym'` zur Auswahl für nummerische oder symbolische Berechnung 
* `t_` 1D-Zeitvektor
* `s_calc` berechneter 3D-Vektor für die Trajektorie (im nummerischen fall ident mit `s`)
* `v_calc` berechneter 3D-Vektor für die lineare Geschwindigkeit
* `a_calc` berechneter 3D-Vektor für die lineare Beschleunigung

### Beispiel

#### Nummerisch

```Matlab
% time
t_start = 0; % s
t_stop = 5; % s
t_step = 0.005; % s

t = (t_start:t_step:t_stop); % s

% frequency
f = 1; % Hz

% trajectory
sx = 0.8 * 5 .* cos(2*pi*f*t); % m
sy = 0.8 * 5 .* sin(2*pi*f*t); % m
sz = 0.3 * 5 .* cos(2*pi*f*t); % m

s = [sx', sy', sz'];

% calculate lineare
[s, v, a] = my_lin(s,"num",t);
```

#### Symbolisch

```Matlab
% time
t_start = 0; % s
t_stop = 5; % s
t_step = 0.005; % s

t = (t_start:t_step:t_stop); % s

% frequency
f = 1; % Hz

% trajectory
sx = @(t) (0.8 .* cos(2*pi*f*t)); % m
sy = @(t) (0.8 .* sin(2*pi*f*t)); % m
sz = @(t) (0.3 .* cos(2*pi*f*t)); % m

s = {sx, sy, sz};

% calculate lineare
[s, v, a] = my_lin(s,"sym",t);
```

## Tangentialwinkel `my_tang`

Mit der Funktion `my_tang` können die Euler-Winkel bestimmt werden, die benötigt werden um einen Vektor vom Inertialsystem in ein Körperkoordinatensystem (ausgerichtet zum Tangentialvektor) zu drehen.


### Syntax
`[phi_tz, phi_ty, phi_tx, ta] = my_tang(v, t)`

### Parameter
* `v` 3D-Vektor der linearen Geschwindigkeit
* `t` Zeit 
* `phi_tz` 1D-Vektor für z-Komponente der Euler-Winkel
* `phi_ty` 1D-Vektor für y-Komponente der Euler-Winkel 
* `phi_tx` 1D-Vektor für x-Komponente der Euler-Winkel
* `ta` 3D-Vektor für Tangentialvektor

### Beispiel
```Matlab
% time
t_start = 0; % s
t_stop = 5; % s
t_step = 0.005; % s

t = (t_start:t_step:t_stop); % s

% frequency
f = 1; % Hz

% trajectory
sx = 0.8 * 5 .* cos(2*pi*f*t); % m
sy = 0.8 * 5 .* sin(2*pi*f*t); % m
sz = 0.3 * 5 .* cos(2*pi*f*t); % m

s = [sx', sy', sz'];

% calculate lineare
[s, v, a = my_lin(s,"num",t);

% calculate tang
[phi_tz, phi_ty, phi_tx, ta] = my_tang(vRef, t);
```

## Winkel Größen `my_ang` 

Mit der Funktion `my_ang` werden die Winkelgeschwindigkeit $\vec{\omega}(t)$ und Winkelbeschleunigung $\vec{\alpha}(t)$ anhand der Euler-Winkel $\vec{\varphi}(t)$ bestimmt.
Dazu werden die Gleichungen xx und xx angewandt.

### Syntax
`[phi_calc, omega_calc, alpha_calc] = my_ang(phi, option, t_)`

### Parameter
* `phi` 3D-Vektor oder Cell mit 3 Vektorfunktionen der Eulerwinkel
* `option` String: `'num'` oder `'sym'` zur Auswahl für nummerische oder symbolische Berechnung 
* `t_` 1D-Zeitvektor
* `phi_calc` berechneter 3D-Vektor für die Euler-Winkel (im nummerischen fall ident mit `s`)
* `omega_calc` berechneter 3D-Vektor für die Winkelgeschwindigkeit
* `alpha_calc` berechneter 3D-Vektor für die Winkelbeschleunigung

### Beispiel

#### Nummerisch
```Matlab
% time
t_start = 0; % s
t_stop = 5; % s
t_step = 0.005; % s

t = (t_start:t_step:t_stop); % s

% frequency
f = 1; % Hz

% trajectory
phix = 0 .* t; % rad
phiy = 0 .* t; % rad
phiz = 0.3 .* cos(2*pi*f*t); % rad

s = [phix', phiy', phiz'];

% calculate angular
[phi, omega, alpha] = my_ang(phi,"num",t);
```

#### Symbolisch
```Matlab
% time
t_start = 0; % s
t_stop = 5; % s
t_step = 0.005; % s

t = (t_start:t_step:t_stop); % s

% frequency
f = 1; % Hz

% trajectory
phix = @(t) (0.8 .* cos(2*pi*f*t)); % m
phiy = @(t) (0.8 .* sin(2*pi*f*t)); % m
phiz = @(t) (0.3 .* cos(2*pi*f*t)); % m

phi = {sx, sy, sz};

% calculate angular
[phi, omega, alpha] = my_ang(phi,"sym",t);
```

## Rotation `my_rotate`

Mit der Funktion `my_rotate` können Punkte oder Vektoren von einem Koordinatensystem (z.B. das Inertialsystem) in ein anderes Koordinatensystem (z.B. das Körperkoordinatensystem gedreht werden).
Dazu kann Gleichung xx verwendet werden.

### Syntax
`[aB] = my_rotate(phi, aN, t)`

### Parameter
* `phi` 3D-Vektor der Euler-Winkel (Orientierung zwischen Inertialsystem und Körperkoordinatensystem)
* `aN` 3D-Vektor im Inertialsystem
* `t` Zeit
* `aB` 3D-Vektor im Körperkoordinatensystem 
* `phi_tx` 1D-Vektor für x-Komponente der Euler-Winkel

### Beispiel
```Matlab
%% time
t_start = 0; % s
t_stop = 5; % s
t_step = 0.005; % s

t = (t_start:t_step:t_stop); % s

%% Frequent
f = 1; % Hz

%% Trajektorie
sx = 0.8 * 5 .* cos(2*pi*f*t); % m
sy = 0.8 * 5 .* sin(2*pi*f*t); % m
sz = 0.3 * 5 .* cos(2*pi*f*t); % m

s = [sx', sy', sz'];

%% Berechnung lineare Größen
[s_N, v_N, a_N = my_lin(s,"num",t);
% lineare Größen im Schwerpunkt S und referenzerit auf das Inertialsystem N

%% Berechnung Tangential Winkel
[phi_tz, phi_ty, phi_tx, ta] = my_tang(vRef, t);

phi = [phi_tx', phi_ty', phi_tz'];

%% Rotation der lineare Beschleunigung
[a_B] = my_rotate(phi, a_N, t); 
% lineare Beschleunigung im Schwerpunkt S und referenzerit auf das Körperkoorinatensystem B
```

## IMU Größen `my_imu`
Mit der Funktion `my_imu` können anhand der Größen im Schwerpunkt $S$ die Winkelgeschwindigkeit und die lineare Beschleunigung im Punkt $I$ bestimmt werden.
Dazu kann Gleichung xx verwendet werden.
Damit die Daten aus der Sicht der IMU bestimmt werden müssen Größen im Schwerpunkt $S$ ins Körperkoordinatensystem $\mathbb{B}$ gedreht werden.
Dazu kann die Funktion `my_rot` verwendet werden.

### Syntax
`[aIMU] = my_imu(aB, omega, alpha, r, t)`

### Parameter
* `aS` 3D-Vektor der linearen Beschleunigung im Körperkoordinatensystem $\mathbb{B}$ am Schwerpunkt $S$
* `omega` 3D-Vektor der Winkelgeschwindigkeit
* `alpha` 3D-Vektor der Winkelbeschleunigung
* `r` Abstandsvektor zwischen Schwerpunkt und IMU 
* `t` 1D-Vektor der Zeit
* `aIMU` 3D-Vektor der linearen Beschleunigung im Körperkoordinatensystem $\mathbb{B}$ am Punkt $I$

### Beispiel
```Matlab
%% time
t_start = 0; % s
t_stop = 5; % s
t_step = 0.005; % s

t = (t_start:t_step:t_stop); % s

%% Frequent
f = 1; % Hz

%% Trajektorie
sx = 0.8 * 5 .* cos(2*pi*f*t); % m
sy = 0.8 * 5 .* sin(2*pi*f*t); % m
sz = 0.3 * 5 .* cos(2*pi*f*t); % m

s = [sx', sy', sz'];

%% Position IMU
r = [-150e-3,-150e-3,50e-3]./2; % m

%% Berechnung lineare Größen
[s_S_N, v_S_N, a_S_N = my_lin(s,"num",t);
% lineare Größen im Schwerpunkt S und referenzerit auf das Inertialsystem N

%% Berechnung Tangential Winkel
[phi_tz, phi_ty, phi_tx, ta] = my_tang(vRef, t);

phi = [phi_tx', phi_ty', phi_tz'];

%% Berechnung Wineklgrößen
[phi, omega, alpha] = my_ang(phi,"num",t); 
% Winkelgrößen des starren Körpers (sind am gesammten Körper ident)

%% Rotation der lineare Beschleunigung
[a_S_B] = my_rotate(phi, a_S_N, t); 
% lineare Beschleunigung im Schwerpunkt S und referenzerit auf das Körperkoorinatensystem B

%% Berechnung IMU Daten
[a_I_B] = my_imu(a_S_B, omega, alpha, r, t)

% a_I_B entspricht gemessenen Beschleunigung der IMU
a_IMU = a_I_B;
% omega entspricht der gemessenen Winkelgeschwindigkeit der IMU
omega_IMU = omega; 
```



