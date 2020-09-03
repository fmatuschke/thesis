Simulation(container::NpArray<int> label_field,
           container::NpArray<float> vector_field,
           container::List phy_properties,
           container::List tilt) {

   signal_0 = GetInitialLightVector();
   global_light_positions = CalcStartingLightPositions(tilt);

   for local_light_ray in global_light_positions: 
      local_light_ray.pos = global_light_ray.pos - dim_.offset
      
      mpi_halo = False
      while local_light_ray.pos inside volume:
            local_light_ray.pos += light_step
        
            // check if communication is neccesary
            mpi_halo = CheckMPIHalo(local_light_ray))
            if mpi_halo:
                break
        
            // get physical parameters
            dn, mu = properties_[label]
            attenuation = exp(-0.5 * mu * thickness)**2;
        
            if (dn == 0 || label == 0)
               if attenuation > 0:
                   for rho in range(filter_rotation):
                      local_light_ray[rho] *= attenuation;
               continue;
        
            optic_axis = GetVec(local_light_ray.pos);
            d_rel = dn * 4.0 * thickness / lambda;
        
            if (tilt.theta != 0)
               optic_axis = vm::dot(rotation, optic_axis);
        
            for rho in range(filter_rotation):
               local_light_ray[rho] = MuellerMatrix(optic_axis, dn) *
                                        local_light_ray[rho]
               local_light_ray[rho] *= attenuation;
            
     if not mpi_halo:
        // light reached end of volume and ccd sensor
        for rho in range(filter_rotation):
           intensity_signal[local_light_ray.ccd_pos, rho] = 
                            (polarizer_y * local_light_ray[rho])[0];

      if (mpi_) 
         // stays in communication loop until
         // all processes finished simulation
         while mpi_->ReduceNumComm == 0:
            global_light_positions.append(mpi_->RecvData());
             
          
   return intensity_signal;
}