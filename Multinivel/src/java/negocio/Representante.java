/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package negocio;

import java.math.BigDecimal;

/**
 *
 * @author thrash
 */
public class Representante {
    private String idRep;
    private char tipoId;
    private String nombre;
    private String apellido;
    private String direccion;
    private String ciudad;
    private String correo;
    private BigDecimal telefono;
    private String genero;
    private String fechaContrato;
    private String fechaNacimiento;
    private int clasificacion;
    private String captadorId;
    private String captadorTipo;
    private String codigoPostal=null;
    private String pass;

    public String getIdRep() {
        return idRep;
    }

    public void setIdRep(String idRep) {
        this.idRep = idRep;
    }

    public char getTipoId() {
        return tipoId;
    }

    public void setTipoId(char tipoId) {
        this.tipoId = tipoId;
    }

    public String getNombre() {
        return nombre;
    }

    public void setNombre(String nombre) {
        this.nombre = nombre;
    }

    public String getApellido() {
        return apellido;
    }

    public void setApellido(String apellido) {
        this.apellido = apellido;
    }

    public String getDireccion() {
        return direccion;
    }

    public void setDireccion(String direccion) {
        this.direccion = direccion;
    }

    public String getCiudad() {
        return ciudad;
    }

    public void setCiudad(String ciudad) {
        this.ciudad = ciudad;
    }

    public String getCorreo() {
        return correo;
    }

    public void setCorreo(String correo) {
        this.correo = correo;
    }

    public BigDecimal getTelefono() {
        return telefono;
    }

    public void setTelefono(BigDecimal telefono) {
        this.telefono = telefono;
    }

    public String getGenero() {
        return genero;
    }

    public void setGenero(String genero) {
        this.genero = genero;
    }

    public String getFechaContrato() {
        return fechaContrato;
    }

    public void setFechaContrato(String fechaContrato) {
        this.fechaContrato = fechaContrato;
    }

    public String getFechaNacimiento() {
        return fechaNacimiento;
    }

    public void setFechaNacimiento(String fechaNacimiento) {
        this.fechaNacimiento = fechaNacimiento;
    }

    public int getClasificacion() {
        return clasificacion;
    }

    public void setClasificacion(int clasificacion) {
        this.clasificacion = clasificacion;
    }

    public String getCaptadorId() {
        return captadorId;
    }

    public void setCaptadorId(String captadorId) {
        this.captadorId = captadorId;
    }

    public String getCaptadorTipo() {
        return captadorTipo;
    }

    public void setCaptadorTipo(String captadorTipo) {
        this.captadorTipo = captadorTipo;
    }

    public String getCodigoPostal() {
        return codigoPostal;
    }

    public void setCodigoPostal(String codigoPostal) {
        this.codigoPostal = codigoPostal;
    }

    public String getPass() {
        return pass;
    }

    public void setPass(String pass) {
        this.pass = pass;
    }
}
